---
name: callfilter-quality-gate
description: Run the non-destructive CallFilter quality gate for a change. Use after implementation and whenever a task must be finished, reviewed or handed off.
---

# CallFilter quality gate

Use the project's real commands. Do not substitute an unverified tool, do not
run `dcm fix`, and do not delete code to make a check pass.

## Gate

1. Format:
   ```bash
   dart format --output=none --set-exit-if-changed lib test integration_test
   ```
2. Static analysis:
   ```bash
   flutter analyze
   ```
3. Generated code, only when models/tables/ARB changed:
   ```bash
   flutter gen-l10n
   dart run build_runner build
   git diff --exit-code
   ```
4. Full Flutter tests:
   ```bash
   flutter test
   ```
5. Architecture tests explicitly (they are part of the full suite, but name the
   result):
   ```bash
   flutter test test/architecture
   ```
6. DCM, only if the CLI is activated:
   ```bash
   ./tool/quality/dcm.sh
   ./tool/quality/dcm.sh full   # Pro+ dead-code/deps/duplication reports
   ```
   If DCM is not installed or not activated, report `NOT RUN` with the exact
   reason. Never report a DCM pass without its output.
7. Security, when native code, dependencies, platform channels or CI changed:
   ```bash
   ./tool/security/check.sh
   ```
   If a scanner is missing, report which one and do not mark the gate green.
8. Android native tests when Kotlin/manifest changed:
   ```bash
   (cd android && ./gradlew testDebugUnitTest)
   ```
9. iOS build/native tests when iOS/native code changed:
   ```bash
   flutter build ios --simulator --no-codesign
   ```
   Run the Xcode test command from `README.md` only when a simulator is
   available; otherwise report it as not run.
10. Integration tests when a device/emulator is available:
    ```bash
    flutter test integration_test -d <device-id>
    ```
    Do not add integration tests to a CI job without a runner.
11. Diff hygiene:
    ```bash
    git diff --check
    git status --short
    ```

## Rules

- Scope expensive checks to the change: full `flutter test` is required before
  completion; native/integration checks are conditional on the changed surface.
- A skipped or unavailable check is **not** a pass.
- On failure, read the output, fix the cause, and rerun. Do not suppress a lint,
  exclude a file, or change a test expectation merely to get green.
- Do not run destructive formatting/fix commands or automatic dead-code
  removal. `dart fix --apply` is not part of this gate.
- Do not change business logic just to satisfy a tool.

## Report

Use a table with `check | command | result | notes`, where result is `PASS`,
`FAIL` or `NOT RUN`. Include the final `git diff --stat` and any residual risk.
