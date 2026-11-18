# Architecture

## Goals

CallFilter must:

1. Keep the product usable without a backend or account.
2. Match organization names with RegExp rules where caller names are available.
3. Never block a whitelisted number.
4. Isolate platform-specific call screening behind interfaces.
5. Stay testable without a device for all business logic and UI flows.
6. Be explicit about the places where Android and iOS cannot provide the same
   behavior.

## High-level shape

The app uses a feature-first layout with a small shared core:

```text
Presentation (Material UI + Riverpod)
        |
        v
Controllers / domain services
        |
        v
Repository interfaces          CallScreeningGateway
        |                              |
        v                              v
Drift repositories -> SQLite      MethodChannel -> Kotlin/Swift
```

Dependencies point inward. Riverpod provider definitions are the composition
root; widgets never construct infrastructure.

## Feature map

| Feature | Responsibility |
| --- | --- |
| `rules` | Organization-name RegExp rules, editor and list UI |
| `contacts` | Whitelist entries and add/remove UI |
| `call_filter` | Normalization, safe regex execution, decision engine, platform gateway and sync snapshot |
| `call_history` | Local blocked-call log |
| `settings` | Filtering/logging toggles, language, platform capability panel |
| `home` | Summary and local caller-check entry point |

Cross-cutting code lives in `lib/core`:

- `database/` — Drift database and tables
- `di/` — Riverpod providers (composition root)
- `errors/` — expected app exceptions
- `logging/` — thin `dart:developer` logging facade
- `regex/` — the only direct `RegExp` construction site
- `utils/` — ID generator

`lib/shared` holds reusable presentation widgets only.

## Domain model

### FilterRule

An immutable Freezed value object:

- `id`
- `name`
- `pattern` (ECMAScript-style RegExp)
- `isEnabled`
- `priority`
- `description?`
- `createdAt`, `updatedAt`

Rules are matching policies, not phone-number blocks. The display-name field is
the only target of a rule.

### ContactWhitelistEntry

`id`, `phoneNumber`, `label`, `createdAt`. Whitelist comparison uses digits only
via `PhoneNumberNormalizer`. The stored phone number keeps the user's formatting
for display.

### BlockedCall

`id`, `phoneNumber`, `organizationName?`, `ruleId?`, `ruleName?`, `blockedAt`.

### CallerInfo

The minimal input to the engine: `phoneNumber` and optional `displayName`.
Platform code is responsible for deciding whether a display name exists.

### CallFilterDecision

`reason` plus an optional `OrganizationMatch`:

```text
filteringDisabled
whitelisted
callerNameUnavailable
matchedRule
noMatchingRule
invalidRulePatterns
regexTimeout
```

`isBlocked` is true only for `matchedRule`. This makes every allowed path
explicit for the UI and future callbacks.

## Rule evaluation

`CallFilterEngine.evaluate`:

1. If filtering is disabled, allow with `filteringDisabled`.
2. Normalize the caller phone number and check the whitelist.
3. If whitelisted, allow with `whitelisted` — before any rule runs.
4. Normalize the display name. If it is empty, allow with
   `callerNameUnavailable`.
5. Keep active rules, sort by `priority` descending and then by name.
6. For each rule:
   - run static `RegexSafetyValidator` checks;
   - run the regex through `RegexMatchRunner`;
   - skip invalid/unsafe patterns and remember that fact;
   - track timeouts.
7. Return a blocked match or an allowed reason (`invalidRulePatterns`,
   `regexTimeout`, `noMatchingRule`).

`OrganizationNormalizer` trims, removes zero-width characters, normalizes
non-breaking space, collapses whitespace and lowercases. Unicode NFKC and
transliteration are intentionally deferred; adding them later is a deliberate
product decision because it changes what rules match.

Phone canonicalization is also intentionally limited to digits. Mapping national
prefixes to an international form would require a country policy.

## Regex safety

Dart's `RegExp` is ECMAScript-style and **has no timeout**. Static validation
alone cannot prove a pattern is ReDoS-safe, so CallFilter uses two layers:

1. **Static validation** (`RegexSafetyValidator`):
   - non-empty and at most 256 characters by default;
   - valid syntax;
   - no control characters;
   - no counted repetition above 1000;
   - heuristic rejection of nested quantifiers such as `(a+)+`.
2. **Runtime isolation** (`IsolateRegexMatchRunner`):
   - one match runs in a separate isolate;
   - the caller gets `timedOut` after 250 ms;
   - the isolate is killed with `Isolate.immediate` on timeout.

The isolate overhead is acceptable for the local caller-check flow. It is more
expensive than a direct `RegExp.hasMatch`, which is why matching is not run
inside every UI rebuild. The design is documented here so a future batch matcher
can preserve the timeout/kill guarantee.

Android's native matcher uses Java `Pattern` with the same static checks, but
there is no killable worker in the current service. That limitation is explicit
in [platform-limitations.md](platform-limitations.md).

## Dependency injection

Riverpod is the sole DI mechanism.

```text
appDatabaseProvider
├── rulesRepositoryProvider
├── whitelistRepositoryProvider
├── callHistoryRepositoryProvider
└── settingsRepositoryProvider

regexSafetyValidatorProvider ─┐
regexMatchRunnerProvider ─────┼──> callFilterEngineProvider
                              │
callScreeningGatewayProvider ─┼──> platformCapabilitiesProvider
                              └──> platformSyncServiceProvider

rulesControllerProvider       (StreamNotifier<List<FilterRule>>)
whitelistControllerProvider   (StreamNotifier<List<ContactWhitelistEntry>>)
callHistoryControllerProvider (StreamNotifier<List<BlockedCall>>)
settingsControllerProvider    (StreamNotifier<AppSettings>)
```

- Repositories are created from the database provider and disposed with the
  provider container.
- The database provider owns and closes `AppDatabase`.
- The gateway provider selects the real MethodChannel implementation on Android
  and iOS, and an unsupported implementation elsewhere or on web.
- Tests override the database, gateway and regex runner through
  `ProviderContainer(overrides: ...)`.
- Controllers expose reactive state and commands. UI watches `AsyncValue` state
  and calls notifier commands; it does not open tables or construct services.

The example DI test is `test/features/rules/rules_controller_test.dart`.

## Presentation and design system

The visual layer is a small design system under `lib/app/theme` and
`lib/shared/widgets`; details and token values are in
[design-system.md](design-system.md).

- The visual direction is Material 3 Expressive with a custom cobalt/teal
  identity. `AppColors` exposes the full Material 3 role set (surface
  containers, on-colours, containers, outline roles) as a `ThemeExtension`.
- `AppTypography`, `AppSpacing`, `AppRadius`, `AppSizes` and `AppMotion` are the
  only sources for type scale, spacing, shapes and timing.
- `AppStatusIndicator`, `AppChip`, tonal `AppCard` variants and the themed
  NavigationBar/NavigationRail provide the shared expressive patterns. Rule
  editor actions are sticky in `AppScaffold.bottomNavigationBar`.
- Feature screens use `App*` components and `context.appColors`/semantic text
  getters. They do not query Drift or create feature-local visual constants.
- `CallFilterApp` maps persisted `AppThemeMode` to Flutter `ThemeMode`; theme
  changes rebuild immediately without restart.
- Navigation uses GoRouter `StatefulShellRoute.indexedStack` with five
  independent branch navigators in `lib/app/router`. Tabs preserve their stacks
  and state; switching tabs does not append artificial history.
- Android system Back is handled by `PopScope`: modals close first, nested pages
  pop within their branch, branch roots return to Home, and only Home exits the
  app. No `WillPopScope` is used.
- Localization remains the existing generated `AppLocalizations`; on Flutter
  3.50 the Material delegates come from `material_ui`, not the generated list.

## Persistence

Drift + SQLite via `drift_flutter`. The app database name is `call_filter`.

| Table | Key fields | Notes |
| --- | --- | --- |
| `filter_rules` | id, name, pattern, is_enabled, priority, created_at, updated_at | text id, priority index not yet added |
| `whitelist_entries` | id, phone_number, label, created_at | unique phone_number |
| `blocked_calls` | id, phone_number, organization_name, rule_id, rule_name, blocked_at | local history |
| `app_settings` | id (=0), filtering_enabled, log_blocked_calls, theme_mode, locale_code | one-row settings; `theme_mode` defaults to `system` |

One-shot reads use direct `select().get()` rather than `watch().first`. A stream
read in a widget test can keep a Drift query subscription alive during teardown;
direct reads also express intent better for non-reactive consumers.

Schema version is **2**. Migration from the original schema adds
`app_settings.theme_mode` with a `system` default. Future table changes must add
a `MigrationStrategy` migration; do not silently mutate an existing schema
version in production.

## Platform integration

`CallScreeningGateway` abstracts:

- `getCapabilities()`
- `syncSnapshot(PlatformFilterSnapshot)`
- `openSystemSettings()`

`PlatformSyncService` builds the snapshot from local repositories:

- filtering enabled;
- active rules;
- digits-only whitelist numbers;
- prepared `CallDirectoryMapping`s from blocked-call history and whitelist
  labels.

The snapshot is JSON with a generated `toJson`/`fromJson` implementation. Native
code stores it in SharedPreferences (Android) or UserDefaults/App Group
(iOS). This is a data bridge, not a blocking guarantee.

Android also has a `CallScreeningService` that reads the snapshot and uses a
pure Kotlin matcher. iOS has Call Directory Extension source that reads prepared
number mappings. See the platform document for the current verification status.

## Error handling

- Repository errors propagate to controllers/UI.
- UI catches `Object`, displays a localized fallback or an explicit
  `AppException.message`, and leaves state backed by the database stream intact.
- `PlatformIntegrationException` wraps channel failures.
- The engine never throws for an invalid user pattern; it records the reason.
- The Android snapshot parser falls back to safe defaults on malformed JSON.

## Testing strategy

- Pure unit tests cover normalization, regex validation, matching order,
  whitelist precedence, missing names, invalid patterns and timeouts.
- Drift in-memory tests cover all repositories and settings defaults.
- Widget tests pump the real app with an in-memory database and overridden
  platform gateway/runner. They cover rule creation, invalid-pattern rejection,
  toggling, and whitelist validation.
- Integration tests use the same app with a real in-memory database on a
  device/simulator, plus a file-backed database reopen test.
- Native tests cover the pure matcher/snapshot parsers. They do not claim to
  test system call screening.

See [testing.md](testing.md) for commands and conventions. Static analysis,
DCM, secret/dependency/SAST scans, SonarQube and CI behavior are documented in
[code-quality.md](code-quality.md).

## Dependencies and compatibility

| Dependency | Version constraint | Why |
| --- | --- | --- |
| `flutter_riverpod` | ^3.5.0 | state and DI |
| `go_router` | ^18.1.4 | declarative navigation and shell |
| `drift` / `drift_flutter` | ^2.35.4 / ^0.3.1 | reactive SQLite |
| `freezed_annotation` / `freezed` | ^3.1.0 / ^4.0.3 | immutable rule and match values |
| `json_annotation` / `json_serializable` | ^4.12.0 / ^6.15.2 | native snapshot JSON |
| `material_ui` | ^1.11.0 | Material widgets for Flutter 3.50 |
| `uuid` | ^4.6.0 | local IDs |
| `very_good_analysis` | ^11.0.0 | static analysis |
| `mocktail` | ^1.0.5 | test doubles |
| `build_runner`, `drift_dev` | tooling | generated code |

Flutter 3.50 / Dart 3.14 constraints are the reason for these floors. Before
changing them, verify with the actual SDK and update the README and CI image.

## Deliberate non-goals for this stage

- No backend, account, sync or telemetry.
- No use case class for each CRUD operation.
- No GetIt/Injectable service locator.
- No second UI kit or parallel theme/component system; Material 3 remains the
  primitive layer under the CallFilter design system.
- No claim of proven system-level blocking on either platform.

## Extension points

- **Real native history:** add a native write path or a callback channel and
  reconcile it into `blocked_calls`; ensure deduplication and permissions.
- **iOS extension target:** add the Call Directory target, App Group entitlement
  and signing; include `CallFilterSnapshot.swift` in the extension target.
- **Scheduled/background sync:** keep snapshots current after rule changes
  without blocking the UI; debounce and expose sync state.
- **Number discovery:** build prepared number-to-organization mappings from
  contacts, call log imports or a future provider while staying local by default.
- **Better ReDoS protection:** a worker pool with a hard deadline and a pattern
  complexity analyzer; do not remove the isolate/kill boundary without proof.
