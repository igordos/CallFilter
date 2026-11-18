# Testing conventions

## Goals

- Protect the rule engine's behavior, not just line coverage.
- Exercise real Drift repositories with an in-memory SQLite database.
- Exercise the real widget tree and navigation with overridden infrastructure.
- Keep platform-native tests honest: parsers/matchers can be unit tested, but
  system call screening requires a physical device.

## Test layout

```text
test/
  helpers/test_app.dart              app pump helper, fake runner, rule builder
  architecture/                      import-level layer dependency guard
  features/call_filter/              engine, normalization, regex safety, phone
  features/data/                     Drift repositories and v1→v2 migration
  features/rules/                    controller DI test, rules widget tests
  features/contacts/                 whitelist widget tests
  features/home/                     dashboard metrics, toggling and quick actions
  features/settings/                 language/theme switch and settings layout tests
  shared/                            design-system and responsive-component tests
  goldens/                           local macOS-only component/screen/theme/responsive goldens
integration_test/
  app_flow_test.dart                 create rule → caller check → whitelist flow
  persistence_test.dart              rule persistence after a file DB restart
  language_switch_test.dart          Russian locale without Material errors
  theme_switch_test.dart             theme persistence after a file DB restart
android/app/src/test/.../            JUnit matcher tests
ios/RunnerTests/                     Swift Testing snapshot parser tests
```

## Commands

```bash
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze
flutter test
```

Native:

```bash
(cd android && ./gradlew testDebugUnitTest)

flutter build ios --simulator --no-codesign
xcodebuild test \
  -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -only-testing:RunnerTests
```

Integration (requires a device or booted simulator):

```bash
flutter devices
flutter test integration_test -d <device-id>
```

The shared UI contracts are covered by widget tests for light/dark themes,
design-system components, large text scaling, language switching, dashboard
metrics, rules and history filters, whitelist, caller check and empty states.
Golden tests in `test/goldens/` are local/macOS-only and skipped on other hosts
because Flutter font rendering differs; semantic widget assertions are the
cross-platform gate. Component goldens cover controls and expressive components;
screen goldens cover Home, Rules, Rule editor, Whitelist, History, Settings and
Caller Check in light/dark, plus empty states, compact English/Russian Home and a wide Home layout.
`test/shared/adaptive_layout_test.dart` verifies the 600 px rail breakpoint,
bounded content width and bounded sheets. `test/shared/long_content_test.dart`
covers 2.0 text scaling, compact empty/populated screens, long Russian content,
the rule editor and the caller sheet. Golden tests load real Roboto and
Material Icons from the local Flutter SDK; they remain macOS-only.

## Unit-test priorities

For each domain change, check:

- normalization of case, whitespace, non-breaking space and zero-width chars;
- case-insensitive matching;
- whitelist precedence over matching rules;
- priority ordering when multiple rules match;
- disabled rules are ignored;
- invalid syntax does not throw and does not block;
- nested quantifiers and excessive repetition are rejected by the validator;
- missing display name results in an allowed call;
- timeout result is reported, not swallowed;
- phone comparison is digits-only.

Use `InlineRegexMatchRunner` for deterministic engine tests and
`TimedOutRegexMatchRunner` for timeout behavior. Do not use the isolate runner in
unit tests unless the test is specifically about isolate behavior.

## Drift repository tests

Use:

```dart
final database = AppDatabase(NativeDatabase.memory());
addTearDown(() => database.close());
```

Test one-shot reads and streams explicitly. Prefer direct `get()` reads for
assertions because stream subscriptions can outlive the test. Widget tests that
mount the app must unmount before closing an overridden database:

```dart
addTearDown(() async {
  await tester.pumpWidget(const SizedBox.shrink());
  container.dispose();
  await database.close();
});
```

`test/helpers/test_app.dart` contains `testContainer(database: ...)` and
`pumpCallFilterApp(...)`.

## Widget tests

- Use `pumpCallFilterApp` with an in-memory database and an unsupported platform
  gateway. Widget tests never call native APIs.
- Use `settle(tester)` (bounded `pumpAndSettle`) so a broken animation fails
  within seconds instead of hanging the suite.
- Use stable keys for actionable widgets:
  - `nav_rules`, `nav_whitelist`, `nav_history`, `nav_home`
  - `add_rule_button`, `save_rule_button`
  - `rule_name_field`, `rule_pattern_field`
  - `add_whitelist_button`, `whitelist_phone_field`, `save_whitelist_button`
  - `check_caller_tile`, `evaluate_caller_button`
- Assert user-visible outcomes and, where useful, repository state. UI tests
  should not query Drift tables directly.
- If a new screen has a loading/error/empty path, cover at least one of them.

## Controller/DI tests

`test/features/rules/rules_controller_test.dart` demonstrates the required
pattern:

```dart
final container = ProviderContainer(
  overrides: [rulesRepositoryProvider.overrideWithValue(repository)],
);
addTearDown(container.dispose);
```

Use mocktail for interface doubles. Register fallback values for custom argument
types. Verify commands are delegated to the repository and watch the provider
through `container.listen` so it stays alive.

## Integration tests

- `app_flow_test.dart` creates a rule through the real UI, reads it back from
  Drift, evaluates a matching caller through the Riverpod-provided engine and
  verifies whitelist precedence.
- `persistence_test.dart` writes a rule to a temporary file-backed SQLite
  database, closes it, reopens it and verifies the rule appears in the app UI
  after the restart.
- Both were verified on an iPhone 17 Pro simulator (iOS 26.3) on 2026-11-16.
  They are **not** part of GitLab CI because a device/simulator runner is
  required. Run them before releases and after changing Drift initialization or
  platform plugins.

Do not replace native integration with mocks and call it device verification.

## Native tests

### Android

`NativeFilterMatcherTest` runs on the JVM and covers normalization, whitelist
matching, case-insensitive matching, priority, unsafe/invalid patterns and the
empty-name case.

```bash
(cd android && ./gradlew testDebugUnitTest)
```

The `android_native_tests` CI job runs this JVM suite. It does not test
`CallScreeningService`, the role UI or real call rejection.

### iOS

`RunnerTests` covers snapshot JSON parsing and safe defaults. It runs in the
simulator through Xcode.

```bash
xcodebuild test \
  -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -only-testing:RunnerTests
```

The Call Directory Extension target is not in the Xcode project yet; a test of
the extension requires adding it to Xcode first, then adding the source files to
that target.

## Architecture imports

`test/architecture/layer_dependencies_test.dart` guards the dependency direction
at the import level:

- feature `domain/` must not import Flutter, `data/` or `presentation/`;
- `presentation/` must not import Drift, the concrete database or `data/`;
- `core/` outside `di/` must not import feature implementations.

This is not a full dependency graph; DCM Pro's dependency analysis is not
enabled without a license. Add file-level exceptions only with a documented
architectural reason.

## Code quality and security checks

The complete tool inventory, local commands and CI behavior are in
[code-quality.md](code-quality.md). After changing quality tooling, run:

```bash
./tool/quality/check.sh
./tool/security/check.sh
```

## Coverage

Coverage is a diagnostic, not a target. Aim for strong coverage of:

- `call_filter/domain/`
- repository mapping/persistence
- rule editor validation
- whitelist precedence
- settings defaults

Do not write meaningless assertions to reach 100%. Do not add coverage-only
tests for generated code.

## CI mapping

The GitLab pipeline runs:

- format check
- `flutter analyze` with very_good_analysis + riverpod_lint
- generated-code freshness (one build_runner/generate job, not repeated)
- DCM analyze/metrics when licensed CI credentials are configured (conditional job)
- Gitleaks, OSV-Scanner and Semgrep in the security stage
- unit tests with coverage, including the architecture test and migration test
- Android JVM native tests
- widget tests, including navigation Back hierarchy and state preservation
- SonarQube when server/token variables are configured
- Android debug APK build
- iOS simulator build on a macOS runner

Generated files are committed; only the `generated_code` job runs the
generators. Update the pipeline if test paths or build requirements change.
