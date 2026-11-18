# AI-assisted development

CallFilter keeps AI guidance in three layers:

1. **Project contract** — `AGENTS.md` plus the topic docs in `docs/`.
2. **Agent Skills** — procedural playbooks in `.agents/skills/`, installed from
   official/community repositories or authored for this project.
3. **Deterministic checks** — format, analyzer, tests, architecture test, DCM
   (when activated), security scans and CI.

The skills never override the project contract. If a third-party skill suggests
a different DI container, state manager, database, router or folder layout, the
CallFilter contract wins.

## Installed skills

There are **25 active skills**: 20 managed external skills (4 official Dart +
2 official Flutter + 11 zakariaf + 2 flutter-pro + 1 Material Design 3 UI) and
5 project skills. Installed with the open Agent Skills CLI into
`.agents/skills/` (copy mode). `skills-lock.json` pins every external source
commit and content hash.

### Official Flutter skills

| Skill | Purpose | Source commit |
| --- | --- | --- |
| `flutter-add-widget-test` | WidgetTester interactions, rendering and user actions | `17fe9182f4c4` |
| `flutter-build-responsive-layout` | LayoutBuilder/MediaQuery/Expanded responsive layouts | `17fe9182f4c4` |

Official source: <https://github.com/flutter/agent-plugins> (Flutter Authors,
BSD-3-Clause). MCP servers and the official architecture/integration skills were
not installed: the architecture skill selects ChangeNotifier/MVVM, and the
integration skill is Flutter Driver/MCP-oriented. CallFilter uses Riverpod and
`package:integration_test`; the project contract and
`callfilter-native-screening`/`callfilter-testing` are authoritative.

### Official Dart skills

| Skill | Purpose | Source commit |
| --- | --- | --- |
| `dart-add-unit-test` | Unit-test structure and regression coverage | `f84b16872b5d` |
| `dart-collect-coverage` | Coverage collection and LCOV reporting | `f84b16872b5d` |
| `dart-run-static-analysis` | Analyzer workflow | `f84b16872b5d` |
| `dart-write-documentation` | Dartdoc/API documentation conventions | `f84b16872b5d` |

Official source: <https://github.com/dart-lang/skills> (Dart project authors,
BSD-3-Clause). The mockito skill was not installed because CallFilter uses
`mocktail` and does not generate mocks.

### Stack-aligned community skills

| Skill | Purpose | Source commit |
| --- | --- | --- |
| `flutter-architecture` | Feature-first, right-sized layers and dependency direction | `e073e5ea10c9` |
| `state-management-riverpod` | Riverpod 3 notifiers, reads/watch/select and lifecycle | `e073e5ea10c9` |
| `persistence-drift` | Drift tables, DAOs, streams, transactions and migrations | `e073e5ea10c9` |
| `widget-composition` | Small widgets, keys, lean `build()`, composition | `e073e5ea10c9` |
| `testing-strategy` | Test shape, fakes, Drift tests and acceptance gates | `e073e5ea10c9` |
| `widget-golden-and-a11y-testing` | Widget harness, text scale, goldens and accessibility limits | `e073e5ea10c9` |
| `flutter-performance` | Rebuild scope, const, lazy lists, isolates and jank | `e073e5ea10c9` |
| `navigation-and-routing` | GoRouter shells, guards, deep links and PopScope | `e073e5ea10c9` |
| `codegen-and-toolchain` | build_runner ownership, generated-code policy and codegen hygiene | `e073e5ea10c9` |
| `i18n-rtl-l10n` | ARB/ICU parity, RTL/bidi and locale handling | `e073e5ea10c9` |
| `ui-states-and-feedback` | Loading/empty/error/retry/feedback states | `e073e5ea10c9` |

Source: <https://github.com/zakariaf/Flutter-Skills> (MIT, commit
`e073e5ea10c963d2c52ab1e423bd314c28a56154`). The suite's canonical stack is
Riverpod 3, go_router, Drift and Material 3. Path examples such as `lib/routing/`
are advisory; CallFilter uses `lib/app/router/`.

The `async-safety` skill was not exposed by the installed revision's CLI, so
async/lifecycle review is covered by `callfilter-code-review` and
`callfilter-quality-gate`.

### Material Design 3 design skill

| Skill | Purpose | Source commit |
| --- | --- | --- |
| `material-design-3-ui` | M3 semantic tokens, component selection, adaptive layout, accessibility, motion and M3 Expressive review | `82783f76de4a` |

Source: <https://github.com/skydashnet/material-design-3-ui-skill> (MIT,
community-maintained, v1.1.1, last upstream commit 2026-09-30). This is **not**
Google-authored; its stated source of truth is the official
<https://m3.material.io/> and <https://developer.android.com/> guidance. It is
platform-agnostic and contains no Flutter dependency or Riverpod/GoRouter
implementation mandate. The upstream package is copied intact so
`skills-lock.json` remains verifiable; its `install.sh`/`uninstall.sh` and
validation tests are vendor files, are not invoked by the agent and must not be
executed as project tooling. The agent reads `SKILL.md` and `references/` only;
`LICENSE` is retained.

Activate it only for UI design, component selection or UI review. CallFilter's
`AGENTS.md`, `docs/design-system.md`, `AppColors`, `AppTypography`,
`AppRadius`, `AppSpacing`, `AppMotion` and existing `App*` components remain
authoritative. Do not use it to add a dependency, replace a component, change
the feature-first architecture, or override the project's token values. It
overlaps intentionally with `flutter-build-responsive-layout`,
`ui-states-and-feedback` and `widget-golden-and-a11y-testing`; use the M3 skill
for design semantics and use those skills for Flutter implementation/testing.
The accessibility reference should be loaded before final UI approval.

### Security and review skills

| Skill | Purpose | Source commit |
| --- | --- | --- |
| `flutter-secure-defaults` | Storage/auth/logging/input/WebView/permission defaults and a read-only checker | `a6f2930bc31e` |
| `dart-flutter-review` | Severity-ranked review orchestration and review heuristics | `a6f2930bc31e` |

Source: <https://github.com/abdelrahman-abied/flutter-pro-skills> (MIT). Only
these two skills were installed, not the full opinionated suite. The secure
defaults skill is for future auth/token/network work; CallFilter has no such
surface today. Its Snyk assessment reported low-risk alerts, and its scripts are
read-only checks; do not run it blindly against a different project. The
intentionally insecure `tests/fixtures/` directories were omitted from the
project copies so fake secrets and vulnerable samples do not enter the
repository or trigger secret scanning. Re-prune them after a skill update.

## CallFilter project skills

| Skill | When it activates | Purpose |
| --- | --- | --- |
| `callfilter-feature` | New/changed feature, model, repository, provider, route, screen or native boundary | Architecture-aware feature planning and implementation |
| `callfilter-quality-gate` | After implementation, before handoff | Format/analyze/tests/codegen/architecture/DCM/security/diff gate |
| `callfilter-code-review` | Before handoff or PR | Independent severity-ranked review |
| `callfilter-native-screening` | Kotlin/Swift/MethodChannel/snapshot/permissions/role changes | Platform truth, physical verification and PII safety |
| `callfilter-testing` | Any change needing tests | Test-layer selection and project-specific test conventions |

## Workflow

1. `callfilter-feature` reads `AGENTS.md`, `docs/architecture.md`, relevant docs
   and the closest existing implementation; it produces a plan before coding.
2. Implement in the existing feature-first structure; do not add a second DI,
   state, database or navigation system.
3. `callfilter-testing` selects the required test layers and writes behavior
   tests.
4. `callfilter-quality-gate` runs the real project commands.
5. `callfilter-code-review` reviews the diff independently.
6. Fix findings and rerun the gate. A skipped/unavailable check is reported as
   `NOT RUN`, never as a pass.
7. If native behavior changed, `callfilter-native-screening` requires a physical
   device or an explicit statement that platform behavior remains unverified.

Optional specialist skills:

- `flutter-secure-defaults` — tokens, auth, storage, logging, permissions.
- `dart-flutter-review` — a second review pass; do not let it override the
  project architecture.
- `flutter-performance` / `widget-golden-and-a11y-testing` — UI performance,
  overflow/large-text and golden/a11y work.

## Quality commands

```bash
./tool/quality/check.sh
./tool/quality/dcm.sh        # only when DCM is activated
./tool/quality/dcm.sh full   # Pro+ reports, if licensed
./tool/security/check.sh
(cd android && ./gradlew testDebugUnitTest)
flutter test integration_test -d <device-id>   # when a device is available
```

DCM 1.40.4 is installed locally only when `tool/ci/install_dcm.sh` is sourced;
the CLI still requires activation. Do not report a DCM pass without output.

## Updating skills

```bash
npx skills update          # from the project root
```

Review the diff of `.agents/skills/`, the source commit in `skills-lock.json`,
and the risk assessment before accepting an update. Remove `tests/fixtures/`
from security/review skills again if the updater restores them. Do not install a
second suite with overlapping architecture/testing/security skills without a
concrete gap. Keep the active catalog under ~30 skills.

## Agent compatibility

`.agents/skills/` is the universal project location used by Codex, Cursor,
Copilot, Antigravity and other Agent Skills-compatible tools. Claude Code and
Codex pointer files (`CLAUDE.md` and `CODEX.md`) deliberately contain no project
rules; they point to `AGENTS.md` so there is one source of truth. No Flutter MCP
server was configured because the project gains no required capability from it
at this stage.
