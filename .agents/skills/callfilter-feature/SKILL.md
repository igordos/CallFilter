---
name: callfilter-feature
description: Plan and implement a new CallFilter feature in the existing feature-first architecture. Use before adding or changing a feature, model, repository, provider, route, screen, native boundary or localization key.
---

# CallFilter feature workflow

CallFilter's existing architecture is the source of truth. Do not introduce an
alternative DI container, state manager, database, router, or layer structure.

## Before writing code

1. Read `AGENTS.md`, `docs/architecture.md`, and the relevant topic doc:
   `docs/design-system.md`, `docs/testing.md`,
   `docs/platform-limitations.md`, or `docs/code-quality.md`.
2. Read the closest existing feature implementation in `lib/features/`.
3. Inspect models, repository interfaces, Drift tables, controllers/providers,
   routes, ARB files and tests that the change may touch.
4. Identify whether the change needs:
   - a domain model or repository contract;
   - a Drift table or migration;
   - a native Android/iOS path or MethodChannel change;
   - new localized strings in both ARBs;
   - generated-code regeneration;
   - migration, unit, repository, widget, golden, native or integration tests.
5. Write a short plan listing affected files, invariants, tests and risks.
   Do not implement until the plan is concrete.

## Material Design 3 UI work

For any screen, component, design-token or navigation-visual change, also load
`material-design-3-ui` after reading `AGENTS.md` and
`docs/design-system.md`. Use it for M3 hierarchy, semantic color roles,
component-by-purpose selection, adaptive structure, accessibility and
anti-pattern review. Its guidance is advisory: CallFilter's `AppColors`,
`AppTypography`, `AppRadius`, `AppSpacing`, `AppMotion`, `App*` components and
feature-first architecture win. Do not add dependencies, replace Riverpod/
GoRouter/Drift, or change existing tokens merely because the skill describes a
generic M3 default. Load its accessibility reference before UI approval.

## Implementation rules

- Keep the feature-first tree: `domain/`, `data/`, `presentation/`.
- Domain code must not import Flutter UI, Drift, data or presentation.
- Presentation must reach persistence through a repository/controller, not
  Drift tables or concrete data classes.
- Register cross-cutting dependencies in `lib/core/di/providers.dart`; feature
  providers may live beside their presentation code.
- Riverpod is the only DI/state mechanism. Use `StreamNotifier`,
  `AsyncNotifier` or `Provider` as appropriate.
- Do not add a use case for simple CRUD. Add one only for a real multi-repository
  policy or workflow.
- Use `App*` design-system components and existing tokens. Do not add local
  colors, font sizes, radii or durations.
- Keep generated files generated. Run `flutter gen-l10n` and
  `dart run build_runner build`; never edit `*.g.dart`, `*.freezed.dart` or
  `lib/l10n/gen/` by hand.
- Preserve stable widget/test keys unless a coordinated test update is part of
  the change.
- Never claim a native/platform capability works without a test or physical
  device evidence.

## Required project checks

After implementation, activate `callfilter-testing`, then
`callfilter-quality-gate`, then `callfilter-code-review`. For any change to
native code or platform channels, also activate
`callfilter-native-screening`.

## Output

Report: plan, changed files, tests added, checks run, checks not run with
reasons, and any remaining risk. Do not mark the task complete while a required
check is failing unexplained.
