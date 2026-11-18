# AGENTS.md

Persistent instructions for AI coding agents working on CallFilter. Read this
file and [docs/architecture.md](docs/architecture.md) before changing code.

## Product and platform truth

CallFilter blocks calls by organization display name where the platform exposes
one, and otherwise uses prepared phone-number mappings. Never claim that a
platform feature works until it has been confirmed by a test or by official
documentation plus a physical-device check.

- Android `CallScreeningService` may receive a caller display name, but the name
  is not guaranteed and presentation can be restricted.
- iOS cannot evaluate RegExp rules or inspect caller names at call time. A Call
  Directory Extension only accepts prepared phone-number blocking/identification
  entries.
- The native Call Directory Extension target is not yet wired into the Xcode
  project. Do not describe the iOS extension as active.
- Do not add fake platform success paths. A MethodChannel may report
  capabilities, but "synced data" is not proof that calls are blocked.

## AI development and skills

- The project contract is this file plus `docs/`. Topic details live in
  `docs/architecture.md`, `docs/testing.md`, `docs/design-system.md`,
  `docs/platform-limitations.md`, `docs/code-quality.md` and
  `docs/ai-development.md`.
- Project and installed skills live in `.agents/skills/`. Use
  `callfilter-feature` before implementation, `callfilter-testing` for test
  selection, `callfilter-quality-gate` before handoff,
  `callfilter-code-review` for an independent diff review and
  `callfilter-native-screening` for Kotlin/Swift/MethodChannel work.
- Third-party skills are advisory. They must not replace Riverpod, Drift,
  GoRouter, `material_ui`, the feature-first layout or existing components.
- Navigation is one `StatefulShellRoute.indexedStack`: keep branch state, do not
  add tab history, and implement Back as modal → nested branch pop → Home →
  exit. Do not add a second router or `WillPopScope`.
- `CLAUDE.md` and `CODEX.md` are pointer files only; do not create competing
  rule sets there.
- A skipped check is reported as `NOT RUN`, never as a pass. Do not run
  `dcm fix` or delete code due to a DCM finding without manual review.

## Architecture rules

- Use feature-first structure: `lib/features/<feature>/{domain,data,presentation}`.
- UI must not call Drift directly or import database tables. Go through a
  repository or a controller.
- Domain/business logic must not import Flutter UI packages.
- Repositories are the persistence boundary.
- Riverpod is the only DI mechanism. Do not add GetIt, Injectable, a global
  service locator, or a second service container.
- Do not create a use case for each simple CRUD operation. Add one only when a
  workflow combines multiple repositories/rules or needs a reusable policy.
- Use `package:material_ui/material_ui.dart` for Material UI. Flutter 3.50
  deprecates `package:flutter/material.dart`.
- Keep `lib/l10n/gen/`, `*.g.dart` and `*.freezed.dart` generated; never hand-edit
  them. Regenerate with `flutter gen-l10n` / `dart run build_runner build`.
- Prefer package imports inside `lib/` (`package:call_filter/...`).

## Design system and UI rules

- Read [docs/design-system.md](docs/design-system.md) before changing any screen.
  The visual direction is Material 3 Expressive with CallFilter's own cobalt/teal
  identity, not stock Flutter Material defaults.
- Use `AppColors` through `context.appColors` and prefer Material role names
  (`onSurface`, `surfaceContainerHigh`, `primaryContainer`, `outlineVariant`,
  `onErrorContainer`, ...). Never introduce local `Color(0x...)`/`Colors.*`
  values in feature code. Only `Colors.transparent` is allowed for layout
  transparency.
- Use `AppTypography` semantic styles (`context.displayStyle`, `titleStyle`,
  `headlineStyle`, `bodyStyle`, `bodySmallStyle`, `labelStyle`, `captionStyle`
  and the additional `displayLargeStyle`/`titleMediumStyle`/`labelMediumStyle`).
  Do not set arbitrary `fontSize` in screens.
- Use `AppSpacing`, `AppRadius`, `AppSizes` and `AppMotion` tokens. Controls use
  the 16 px control radius, cards 24, dialogs/sheets 28, primary/destructive
  buttons and badges full pills. Do not hardcode padding/radius/durations in
  features or make every surface the same shape.
- Prefer tonal surfaces over shadows. `AppCard` groups related content; do not
  wrap every list row or setting in a card.
- `AppScaffold` centers screen content at `AppSizes.pageMaxWidth`; do not stretch
  mobile layouts edge-to-edge on wide windows. Bottom sheets are capped at
  `AppSizes.sheetMaxWidth`. Navigation rail starts at 600 logical pixels; both
  rail and compact bottom navigation are icon-only and keep semantic labels
  plus tooltips.
- Reuse `AppScaffold`, `AppButton`, `AppIconButton`, `AppTextField`,
  `AppSearchField`, `AppCard`, `AppStatusIndicator`, `AppChip`, `AppListTile`,
  `AppBadge`, `AppSwitch`, `AppSelectTile`, `AppDialog`,
  `showAppBottomSheet`, `AppSegmentedControl`, `AppBottomNavigationBar`,
  `AppEmptyState`, `AppErrorState` and `AppLoadingState` before adding a widget. Use `AppScaffold.bottomNavigationBar` for sticky form
  actions.
- Follow the established screen patterns: dashboard = status hero + real metrics
  + one compact tonal quick-action module + recent activity; rules/history =
  search + `AppSegmentedControl` filters + grouped compact list rows; editor =
  section cards + sticky save bar; settings = app hero + grouped sections. Keep
  short quick-action labels visible and put the full action name in
  tooltip/semantics.
- Maintain all UI states: loading, loaded, empty, error, disabled, saving and
  validation error. Loading uses the shared skeleton; empty states offer a next
  action where one exists. Show success only after the awaited operation
  completes.
- Icon-only controls require tooltips; interactive targets are at least 48 px.
  State must not be communicated by colour alone. Selected `AppChip` includes a
  check icon. Status surfaces use a live region and text labels. Caption and hint
  text must use `onSurfaceVariant`, not `outline`.
- New user-visible strings belong in both ARBs. Check English and Russian lengths,
  large text scaling, keyboard insets, safe areas and small screens. Preserve
  stable widget keys used by tests.
- Theme mode is part of `AppSettings` (Drift `app_settings.theme_mode`, schema v2).
  Do not add a second theme or preferences store. Use `SettingsController`.
- Respect `MediaQuery.disableAnimationsOf(context)` for non-essential animation.
- Do not add a UI kit, custom font or dependency for a single visual element.
- Update `docs/design-system.md` when adding a reusable component, token or
  screen pattern.

## Adding a feature

1. Define the domain model and repository interface first, if persistence is
   involved. Keep models immutable.
2. Add Drift tables only in `lib/core/database/app_database.dart`. Use a schema
   migration when changing an existing table; do not rely on destructive schema
   changes in production.
3. Implement the repository in the feature's `data/` directory.
4. Register the repository and any cross-cutting services in
   `lib/core/di/providers.dart`.
5. Expose reactive state with `StreamNotifier`/`AsyncNotifier`; commands belong
   on the notifier, not directly in widgets, unless it is trivial UI state.
6. Add/update routes in `lib/app/router/app_router.dart` and add localized text
   to both `app_en.arb` and `app_ru.arb`.
7. Add tests before declaring the feature complete, including its loading,
   empty/error and large-text states where relevant.
8. Update `docs/architecture.md` if the dependency graph, schema or a
   cross-cutting rule changes; update `docs/design-system.md` for new reusable
   visual patterns.

## Dependency injection rules

- Define providers in `lib/core/di/providers.dart` or the feature's presentation
  provider file.
- Prefer interfaces at boundaries: repositories, `CallScreeningGateway`,
  `RegexMatchRunner`, `IdGenerator`.
- Tests override providers through `ProviderContainer(overrides: ...)` or
  `ProviderScope(overrides: ...)`. See
  `test/features/rules/rules_controller_test.dart` for a repository override and
  `test/helpers/test_app.dart` for the app-level test container.
- Do not construct a database, repository, gateway or engine inside a widget.
- Dispose owned resources with `ref.onDispose`.

## Call filter invariants

- Normalize caller names with `OrganizationNormalizer` before matching.
- Normalize phone numbers to digits only for whitelist comparison.
- Whitelist comparison happens before rule evaluation.
- Only active rules are evaluated. Sort by priority descending, then name.
- Invalid or unsafe rules are skipped; they must never crash evaluation.
- A missing caller display name must result in an allowed call with
  `CallerNameUnavailable`.
- `CallFilterEngine` performs matching through `RegexMatchRunner`; the production
  runner isolates matching and enforces a timeout. Keep that boundary.
- Do not use `RegExp` directly outside `lib/core/regex/regexp_factory.dart`
  without a documented reason. Dart 3.14 deprecates direct `RegExp` usage in
  preparation for making the class final.
- Do not add a "block all" fallback for missing names or invalid patterns.

## Testing requirements

- New domain logic needs unit tests.
- New repository behavior needs a Drift in-memory test.
- New screens or meaningful interactions need widget tests.
- Platform channel/native code must not be mocked as proof of platform behavior.
  Test pure parsers/matchers; state that device APIs remain unverified.
- Run the full quality gate before finishing:
  ```bash
  ./tool/quality/check.sh
  ```
  It performs format checking, `flutter analyze` (very_good_analysis +
  riverpod_lint) and the full Flutter test suite.
- When DCM 1.40.4 is installed, run the non-destructive DCM report:
  ```bash
  ./tool/quality/dcm.sh        # Free+ checks
  ./tool/quality/dcm.sh full   # Pro+ dead-code/dependency/duplication reports
  ```
  Analyze/metrics are blocking when DCM is licensed; other findings are
  report-only. Never run `dcm fix` in CI or delete code from a finding without
  manual review. See [docs/code-quality.md](docs/code-quality.md).
- Run security scans when touching native code, dependencies, platform channels
  or CI:
  ```bash
  ./tool/security/check.sh
  ```
  See [docs/code-quality.md](docs/code-quality.md). Do not suppress findings
  merely to make a pipeline green.
- If Android/iOS native files changed, also run:
  ```bash
  (cd android && ./gradlew testDebugUnitTest)
  flutter build ios --simulator --no-codesign
  ```
  Run the Xcode test command from the README when a simulator is available.
- Do not reduce coverage just to hit a percentage. Prioritize normalization,
  whitelist precedence, invalid/unsafe regex handling, priority order and
  repository persistence.

## Compatibility and dependencies

- Check pub.dev SDK/Flutter constraints before adding a dependency.
- Prefer existing packages; do not add a library for something small that can be
  implemented and tested locally.
- Do not add a backend, authentication, analytics, crash reporting or cloud
  services without an explicit product decision.
- After dependency changes run `flutter pub get`, `flutter analyze`, tests, and
  update this file or `docs/architecture.md` if the stack changes.
- Do not use `dynamic` without a concrete reason. Prefer typed models and
  explicit error handling.

## Public interfaces

- Avoid changing public domain/repository/gateway interfaces without updating
  all implementations, tests, docs and generated code.
- When a breaking change is necessary, prefer a narrow addition over a rename,
  and document the reason in the commit/PR.
- Do not edit generated Drift/Freezed files. Change the source and regenerate.

## Quality and style

- Follow `very_good_analysis` plus the `riverpod_lint` analyzer plugin. Do not
  disable a lint without a comment that explains the architectural reason.
  Current deliberate exceptions:
  - `unnecessary_type_name_in_constructor` is disabled because the project keeps
    conventional constructor syntax for reviewer familiarity.
  - `prefer_initializing_formals` is disabled because dependencies use named
    public parameters while fields remain private.
  - `unnecessary_raw_strings` is suppressed locally in the normalizer because the
    raw string keeps a zero-width RegExp expression readable.
- Keep classes small and focused. Explicitly catch errors at UI boundaries and
  show localized feedback.
- Respect the architecture import test in
  `test/architecture/layer_dependencies_test.dart`: domain must not import
  Flutter/data/presentation, presentation must not import Drift/concrete data,
  and core outside `di/` must not import features.
- DCM metrics are configured in `analysis_options.yaml`; cognitive complexity
  and code duplication are not available in the free DCM feature set used here.
  See `docs/code-quality.md` before changing thresholds or adding ignores.
- Never commit secrets, API keys, signing credentials or machine-specific paths
  (`android/local.properties` is ignored). Gitleaks/Sonar/DCM credentials belong
  in GitLab CI/CD variables only.

## Localization

- Add user-visible strings to both ARB files. Run `flutter gen-l10n`.
- Use `GlobalMaterialLocalizations.delegates` from
  `package:material_ui/material_ui.dart` in `CallFilterApp`, not the generated
  `AppLocalizations.localizationsDelegates`. On Flutter 3.50 the generated list
  references the deprecated `flutter_localizations` Material delegate, which
  does not satisfy `MaterialApp` from `material_ui` for non-English locales
  (symptom: "No MaterialLocalizations found" after switching to Russian).
- Keep `test/features/settings/language_switch_test.dart` and the corresponding
  integration test passing when changing localization wiring.
- Native capability details currently come from Kotlin/Swift and may be English;
  if localized, add a mapping in Dart and document it.

## Current known gaps

- Native blocked calls are not written into the Flutter call-history table.
- iOS Call Directory Extension target/App Group is manual Xcode setup.
- Android call screening was exercised on a physical Samsung SM-S928B
  (2026-11-16): unknown callers reached `CallFilterScreeningService`, but calls
  from stored contacts bypassed it and were routed to Samsung's own service.
  Do not claim contact-name blocking works on that OEM.
- Native Android regex matching has static safety checks and a 1.5 s
  fail-open evaluation bound. A timed-out Java regex worker may still finish
  independently; do not describe this as a complete ReDoS guarantee.
- Snapshot sync is automatic on app start and after rules, whitelist, settings
  or history changes via `PlatformSyncCoordinator`; the manual Settings action
  remains as a recovery/diagnostic control.
- Database schema is version 2. Migration v1→v2 adds
  `app_settings.theme_mode`; there is a migration test in
  `test/features/data/migration_test.dart`. Future schema changes must add a
  forward-only migration and a migration test.
- DCM 1.40.4 can be installed with `tool/ci/install_dcm.sh`, but the local CLI
  is not activated, so no DCM report/baseline has been measured. CI requires a
  Teams+ key for the conditional `code_metrics` job.
- SonarQube has not been executed without a server/token; its Dart support may be
  incomplete for Dart 3.14.
- Semgrep covers Kotlin/Swift only; Dart is covered by analyzer/security scans
  and the custom architecture test.
- Three local macOS-only golden tests exist (base controls and expressive
  components in light/dark); they are skipped on other hosts. Do not make
  golden tests the cross-platform CI gate.
- The design system uses the platform font; there is no branded font asset yet.
