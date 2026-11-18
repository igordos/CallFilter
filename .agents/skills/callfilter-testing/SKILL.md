---
name: callfilter-testing
description: Choose and write the required Test coverage for a CallFilter change. Use when adding domain logic, repositories, Drift migrations, Riverpod state, screens, native code or UI states.
---

# CallFilter testing strategy

Tests must verify behavior and invariants. Do not add tests only to increase a
count. Do not weaken existing tests to make a change pass.

## Matrix

| Change | Required tests |
| --- | --- |
| Normalizer, regex safety, decision engine, priority/whitelist policy | Pure unit tests with deterministic `RegexMatchRunner`; boundary and error cases. |
| Repository or Drift table | In-memory Drift tests; CRUD, ordering, uniqueness, defaults and transaction behavior. |
| Schema/migration | Open a v1 database and assert v2 data/defaults with `NativeDatabase.memory(setup: ...)`. |
| Riverpod controller/provider | `ProviderContainer` overrides; verify state, commands, disposal and error propagation. |
| Screen or interaction | Widget tests using `test/helpers/test_app.dart`; loading, empty, error, disabled, saving, validation. |
| Design-system component | `test/shared/design_system_test.dart` or a focused widget test; large text. |
| Responsive/accessibility | 360×740, 1.35 text scale, safe area, semantics/tap targets. |
| Golden-sensitive UI | Local macOS-only golden; never make it the Linux CI gate. |
| Android native matcher/parser | JUnit under `android/app/src/test`; no claim about system screening. |
| iOS snapshot/parser | Swift Testing under `ios/RunnerTests`; no claim about blocked calls. |
| Platform channel behavior | Unit-test pure parsers/snapshots; physical-device test for actual screening. |

## Commands

```bash
flutter test
flutter test test/architecture
flutter test test/features/data
(cd android && ./gradlew testDebugUnitTest)
flutter build ios --simulator --no-codesign
```

Integration tests require a device/emulator:

```bash
flutter test integration_test -d <device-id>
```

If the environment has no device, report integration tests as `NOT RUN`; do not
fake them.

## Fixtures and overrides

- Use `testContainer(database: ...)` and `pumpCallFilterApp` from
  `test/helpers/test_app.dart`.
- Override repositories, `CallScreeningGateway` and `RegexMatchRunner` at
  provider boundaries.
- Use `InlineRegexMatchRunner` for deterministic engine behavior and
  `TimedOutRegexMatchRunner` for timeout behavior.
- Use `mocktail` for external boundaries when a fake is not clearer.
- Prefer `NativeDatabase.memory()` for repositories; close the database after
  unmounting widgets to avoid teardown hangs.

## Required assertions

- Whitelist wins before rules.
- Only active rules run; priority descending then name.
- Missing caller name allows with `CallerNameUnavailable`.
- Invalid/unsafe patterns never crash and never block.
- Settings and repository writes persist after reopen where relevant.
- UI success appears only after the awaited operation succeeds.

Report the tests added, the tests run, and any test surface intentionally left
manual with the reason.
