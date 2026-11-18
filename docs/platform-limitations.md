# Platform limitations

This document is part of the contract for CallFilter. It separates **shared
business logic** from **platform mechanisms** and records what has actually been
verified. Do not upgrade a row in the verification table without running the
corresponding test on the named environment.

## Why caller-name filtering is asymmetric

The product wants to block calls from an organization even when it uses many
numbers. That requires reading the organization name attached to an incoming
call. The two platforms expose very different data:

| Capability | Android | iOS |
| --- | --- | --- |
| Run app code when a call is screened | `CallScreeningService`, after user grants the role | No arbitrary runtime screening API |
| Read caller display name | Sometimes, via `Call.Details.getCallerDisplayName()` (API 23+); not guaranteed and can be restricted | No API for arbitrary apps |
| Apply RegExp at call time | Yes, in native code | No |
| Block a specific number | Yes, via a screening response | Prepared blocking entries in a Call Directory Extension |
| Identify a number with a label | Yes, per screening flow / prepared mapping | Prepared identification entries in a Call Directory Extension |
| User opt-in | Call screening role / settings | Enable the extension in Phone settings |
| Works offline | Yes | Yes |

A shared RegExp engine therefore cannot be the only mechanism. The Flutter app
uses the engine for local checks and Android native matching; iOS consumes
prepared phone-number mappings only.

## Android

### CallScreeningService

- Added in API 24. The app's `minSdk` is 24.
- The service must be declared with
  `android.permission.BIND_SCREENING_SERVICE` and the
  `android.telecom.CallScreeningService` intent filter.
- On Android 10+ the user grants the call screening role through `RoleManager`.
  Before Android 10 the enablement flow is system/device-specific.
- The service receives `Call.Details`. It must call `respondToCall` with a
  `CallResponse`. The response can disallow the call and skip notifications; it
  is not a permanent global block list entry.
- The implementation in this repository is compiled into the debug APK. It has
  **not** been exercised on a physical device in this environment.

### OEM contact-call routing (verified on Samsung)

On a physical Samsung SM-S928B running Android 17 with CallFilter granted the
call-screening role and selected as `DefaultCallScreeningApp`:

- unknown callers were bound to and evaluated by
  `CallFilterScreeningService`;
- calls from a stored contact were routed only to Samsung's
  `com.samsung.android.incallui` screening service;
- the telecom log for such a contact call had an empty
  `CALLER_DISPLAY_NAME` and a `contact exists` marker;
- CallFilter was not invoked, so neither a name rule nor a number rule inside
  the app can block that call on this OEM configuration.

This is an OEM/telecom routing limitation, not proof that the matcher works or
fails for contact calls. A stock Android build or a different OEM may behave
differently and must be tested separately. Do not claim that contact-name
blocking works on Samsung based on this implementation.

### Caller display name is not guaranteed

`Call.Details.getCallerDisplayName()` is available from API 23, but:

- a carrier/device may supply no name;
- the presentation may be restricted;
- the name may be a contact name, a business name, an operator string or
  another system-provided label;
- name text can be localized, abbreviated or differ from what a user typed into
  a rule.

The service treats a missing/blank name as "cannot apply name rules" and allows
the call. It never blocks on missing data. The UI reports caller display name as
**Limited**, not **Yes**.

### Native matching and safety

`NativeFilterMatcher` uses `java.util.regex.Pattern` with
`CASE_INSENSITIVE | UNICODE_CASE`. It:

- normalizes whitespace and lowercases the name;
- compares whitelist numbers by digits only;
- rejects empty/too-long patterns and control characters;
- rejects the same nested-quantifier heuristic as the Dart validator;
- skips invalid patterns.

Java's regex engine has no interruptible timeout. The native service evaluates
rules on a dedicated worker and waits at most 1.5 s; on timeout it responds with
allow rather than blocking. The static checks are still a mitigation, not a
complete ReDoS guarantee, and a timed-out worker may finish independently. A
production release should use a vetted linear-time matcher for hostile
patterns.

### Blocked-call history from native callbacks

The current Android service does not write a row into the Flutter Drift
database. The in-app caller check writes history; real native screening does
not. This remains a known gap. Native diagnostics are structured Logcat
events with an operation id, snapshot version, rule/whitelist counts, decision
reason and phone hash; they do not contain phone numbers or caller names.

### Required release checks

1. Build and install a signed/debug APK on a physical device.
2. Grant the call screening role.
3. Confirm the app receives a real call and that a display name is present for
   the test carrier/device.
4. Test missing-name, restricted-name, whitelisted-number and invalid-pattern
   cases.
5. Confirm the call log/notification behavior matches the response flags.
6. Test the role-request and app-settings intents from multiple Android
   versions you intend to support.

Official references:

- <https://developer.android.com/reference/android/telecom/CallScreeningService>
- <https://developer.android.com/reference/android/telecom/Call.Details>
- <https://developer.android.com/reference/android/app/role/RoleManager>

## iOS

### Call Directory Extension

- iOS does not let a third-party app evaluate arbitrary caller names or run
  custom RegExp logic during an incoming call.
- A Call Directory Extension (`CXCallDirectoryProvider`) receives a request from
  the system and can add **prepared** blocking and identification entries by
  phone number.
- Blocking and identification entries must be added in ascending numeric order.
  The extension source sorts and deduplicates before adding them.
- The extension has a limited time budget, so work must be prepared ahead of
  time.
- The user must enable the extension in Settings → Phone → Call Blocking &
  Identification (wording varies by iOS version).
- The extension does not get a caller name at runtime. It can only provide a
  label for a number that was already known.

### Current repository state

- The iOS host app has a MethodChannel for capabilities, snapshot sync and
  opening Settings.
- `CallFilterSnapshot.parse` is compiled into the Runner target and tested with
  Swift Testing.
- `ios/CallDirectoryExtension/CallDirectoryHandler.swift` and its `Info.plist`
  are provided as the extension source.
- **The Call Directory Extension target is not added to
  `Runner.xcodeproj`.** As a result, the extension is not built, signed or
  exercised by `flutter build ios`. Do not claim that iOS blocking is active.

### Manual target checklist

1. Open `ios/Runner.xcworkspace` (or `Runner.xcodeproj`) in Xcode.
2. Add a Call Directory Extension target named `CallDirectoryExtension`.
3. Add `CallDirectoryExtension/CallDirectoryHandler.swift`,
   `CallDirectoryExtension/Info.plist` and `Runner/CallFilterSnapshot.swift` to
   the extension target.
4. Add the App Group capability `group.com.callfilter.callFilter` to both Runner
   and the extension. The group identifier is defined in
   `CallFilterSnapshot.appGroupIdentifier`.
5. Add the Runner target to the extension's embedded content, if Xcode has not
   done so.
6. Build for a real device, enable the extension in Phone settings, prepare
   mappings, then verify labels/blocking with real calls.
7. Add a CI job that builds the extension target; the current pipeline only
   builds the simulator app.

### What maps to what

`PlatformSyncService` creates a snapshot with `directoryMappings`:

- blocked-call history → `shouldBlock: true` mappings (when a number is known);
- whitelist labels → `shouldBlock: false` identification mappings.

These mappings are prepared for iOS only. Android intentionally ignores them
during screening: they are derived from history and could otherwise keep
blocking a number after its rule was removed or disabled. Because real native
history is not wired back yet, the mappings are built from local caller-check
history; this is not a complete call-log import pipeline.

Official references:

- <https://developer.apple.com/documentation/callkit/cxcalldirectoryprovider>
- <https://developer.apple.com/documentation/callkit/cxcalldirectoryextensioncontext>
- <https://developer.apple.com/documentation/callkit/identifying-and-blocking-calls>

## Verification status

| Item | Status | Evidence |
| --- | --- | --- |
| Dart rule engine (normalization, whitelist, priority, invalid patterns) | Verified | `flutter test` |
| Drift repositories and persistence | Verified | repository tests + integration persistence test source |
| Flutter UI rule/whitelist flows | Verified | widget tests |
| App navigation and caller check | Verified | widget test + iOS simulator integration test |
| Android debug APK build | Verified | `flutter build apk --debug` |
| Android native matcher | Verified as JVM unit tests | `./gradlew testDebugUnitTest` |
| Android automatic snapshot sync | Verified on emulator API 36 | snapshot with `schemaVersion=1` in SharedPreferences after cold start and after rule save |
| Android CallScreeningService binding and callback | Verified on emulator API 36 | `SCREENING_BOUND`, structured log with snapshot/rules/whitelist and `responded` |
| Android blocked response with a real caller name | **Not verified** | emulator supplied no caller name; contact calls bypassed screening |
| Android call screening on a physical device | **Not re-verified after this change** | phone was disconnected; previous Samsung result still applies |
| Android real-call history writeback | **Not implemented** | known gap |
| iOS simulator app build | Verified | `flutter build ios --simulator --no-codesign` |
| iOS snapshot parser | Verified | `RunnerTests` in Xcode simulator |
| Integration app flow and app restart persistence | Verified on iOS simulator | `flutter test integration_test/...` (iPhone 17 Pro, 2026-11-16) |
| iOS Call Directory extension source | Type-checks with the iOS simulator SDK | `swiftc -typecheck`; target still not wired |
| iOS Call Directory extension build | **Not wired** | target/App Group not added |
| iOS real call blocking/identification | **Not verified** | requires extension target + physical device |
| Integration tests in CI | Not configured | run manually on device/simulator |

## Privacy and security

- Rules, whitelist, history and settings are local SQLite/UserDefaults data.
- No backend, account, analytics or network service is used.
- Android backup is disabled in the manifest; the app makes no network requests.
- Snapshot data is written to the platform's local store and, on iOS, should be
  shared through the App Group only after the capability is configured.
- Treat caller names and phone numbers as personal data: do not log raw values in
  production, and delete them when the user clears history.

## Product implications

- A rule such as `ооо\s+работа` can only work where a display name is supplied.
- iOS users get prepared number blocking/identification, not arbitrary
  organization-name matching.
- Never advertise cross-platform parity for name-based blocking.
- The UI must show capability differences honestly; the Settings screen already
  reports Android caller display name as **Limited** and iOS runtime screening as
  **No**.
