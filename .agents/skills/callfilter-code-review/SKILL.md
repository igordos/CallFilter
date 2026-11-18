---
name: callfilter-code-review
description: Independently review a CallFilter diff for correctness, architecture, async/resource safety, Riverpod/Drift lifecycle, localization, accessibility, security and regressions. Use after implementation and before handoff.
---

# CallFilter code review

Review the diff, not the author's intention. Do not turn style preferences into
defects. Do not edit code unless the user explicitly asked for fixes.

## Evidence

Start with:

```bash
git status --short
git diff --stat
git diff
```

Read the affected implementation and the relevant docs:
`AGENTS.md`, `docs/architecture.md`, `docs/testing.md`,
`docs/design-system.md`, `docs/platform-limitations.md`.

## Checklist

### Correctness and architecture

- Domain code remains free of Flutter/Drift/data/presentation imports.
- Presentation does not import Drift tables or concrete repositories directly.
- Riverpod is still the only DI/state mechanism; no second container.
- Repository boundaries and public interfaces remain coherent.
- No duplicated business logic; reuse existing normalizers, engine, sync service.
- No unrelated architecture changes or generated-file edits.
- SOLID: responsibilities, dependency direction, interface size, duplication.

### Async, lifecycle and resources

- Every `await` is followed by a `mounted`/`context.mounted` guard where needed.
- `Future`-returning callbacks are not silently dropped.
- TextEditingControllers, focus nodes, stream subscriptions, timers, isolates
  and receive ports are disposed/closed.
- Provider disposal and database lifecycle are correct.
- No race between read-modify-write settings changes or snapshot reads.
- Errors are handled at the UI boundary; expected `AppException` messages are
  used and localized.

### Data and migrations

- Drift writes are transactional where multiple records must agree.
- Schema changes include a forward-only migration and a v1→v2-style test.
- Generated code is regenerated, not hand-edited.
- Duplicate/ignored inserts produce truthful UI feedback.
- Native snapshot includes active rules, whitelist precedence and settings.

### UI, localization and accessibility

- Both ARB files contain every new key; placeholders match.
- Loading, empty, error, disabled, saving and validation states exist.
- Large text, 360 px width, safe areas and keyboard insets are handled.
- Touch targets are at least 48 px; icon-only actions have tooltips/semantics.
- State is not conveyed by colour alone.
- New components reuse the design system and tokens.

### Security and platform truth

- No secrets, tokens, signing material or machine paths are committed.
- Caller PII is not logged in release builds; debug logs are intentional and
  bounded.
- Native claims are backed by tests or physical-device verification.
- Samsung contact-call routing, iOS Call Directory limits and missing native
  history are not described as solved.
- Permissions/roles are requested at the right time and failures are surfaced.

### Performance and regressions

- No unnecessary rebuilds, unbounded lists or work inside `build`.
- No large synchronous parsing/DB queries on the UI isolate.
- Existing user flows and public behavior are covered by tests.
- New tests assert behavior, not implementation noise.

## Material Design 3 review

For any diff touching `lib/app/theme/`, `lib/shared/widgets/` or a feature
screen, load `material-design-3-ui` after the project docs. Use its
`references/anti-patterns.md`, component-selection, adaptive-design,
accessibility and m3-expressive guidance to review:

- semantic color roles and token discipline;
- component choice by purpose rather than appearance;
- card/containment overuse and expressive restraint;
- adaptive structure across compact/medium/expanded windows;
- accessibility, text scaling, focus, semantics and reduced motion;
- missing loading/empty/error/disabled states.

The project's `docs/design-system.md` and existing tokens/components are the
source of truth. Do not report a generic M3 default as a defect when CallFilter
deliberately uses its own documented token or component. Do not use this skill
to justify a UI rewrite, dependency, architecture change or Riverpod/GoRouter
replacement. If the diff is not UI-related, skip this section.

## Finding format

For each real finding:

```text
[severity: Critical|High|Medium|Low] file:line
Problem: ...
Impact: ...
Fix: ...
```

Include a short verification note (test, command or code path). If no findings,
state what was inspected and which checks were not run. Do not claim tests passed
if they were not run.
