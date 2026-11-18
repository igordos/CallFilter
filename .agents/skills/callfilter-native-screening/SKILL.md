---
name: callfilter-native-screening
description: Change or review CallFilter Android/iOS call-screening code, MethodChannel contracts, native snapshots, permissions/roles or platform capability claims. Use for Kotlin, Swift, manifest, snapshot and call-screening behavior changes.
---

# CallFilter native screening

Read `docs/platform-limitations.md` and `AGENTS.md` before changing native code.
The Flutter domain engine is not proof that the platform blocks or identifies a
call.

## Current truth

- Android uses `CallScreeningService`; the call-screening role must be granted.
- Android may provide `callerDisplayName`; it is not guaranteed.
- iOS cannot evaluate RegExp or inspect caller names at call time. A Call
  Directory Extension only uses prepared number mappings.
- The iOS extension target/App Group is manual Xcode setup and is not active in
  the repository until wired.
- On the tested Samsung device, unknown callers reached
  `CallFilterScreeningService`, but stored-contact calls were routed only to
  Samsung's own service. Do not claim contact-name blocking works there.
- Native blocked calls are not written back to the Flutter history table.
- Android native regex matching has static safety checks and a 1.5 s
  fail-open evaluation bound; a timed-out worker may still finish.
- `PlatformSyncCoordinator` syncs on app start and after repository changes;
  the Settings action remains manual recovery. Do not describe rules as active
  in native until sync and a physical call are verified.

## Work

1. Inspect `CallScreeningGateway`, `MethodChannelCallScreeningGateway`,
   `PlatformSyncService`, `NativeFilterMatcher`, `CallFilterPreferences`,
   `CallFilterScreeningService` and the iOS snapshot/extension sources.
2. Confirm the channel method names and JSON shape; update Dart and native
   together if the contract changes.
3. Preserve whitelist precedence and fail-open on missing caller names.
4. Keep debug logging free of unbounded PII. Prefer presence/length/rule name;
   never log phone numbers or full caller names in release builds.
5. Add pure parser/matcher tests. Do not mock system call screening as proof.
6. Verify on a physical device:
   - role holder;
   - service binding;
   - caller-name presence/absence;
   - whitelist;
   - contact vs unknown caller routing;
   - sync snapshot contents.
7. Run native checks:
   ```bash
   (cd android && ./gradlew testDebugUnitTest)
   flutter build ios --simulator --no-codesign
   ```
   Run Xcode tests when a simulator is available.

## Prohibited

- Claiming platform success from a MethodChannel response or a synced snapshot.
- Adding a block-all fallback for missing names/invalid regex.
- Removing runtime isolate boundaries from Flutter engine code.
- Editing generated native/Dart registration files by hand.
- Adding permissions or platform behavior without updating docs and physical
  verification notes.

Report what was verified on which device, and what remains unverified.
