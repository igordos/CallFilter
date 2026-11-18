# Code quality and security

CallFilter uses a small set of complementary checks. The goal is to catch
real defects and boundary violations, not to maximize the number of tools.

## Tool inventory and versions

| Tool | Pinned version | Role | Availability |
| --- | --- | --- | --- |
| Flutter / Dart | 3.50.0 / 3.14.0 | SDK and analyzer | Public |
| very_good_analysis | 11.0.0 | primary lint set | Public |
| riverpod_lint | 3.2.0 | Riverpod-specific analyzer plugin | Public |
| Dart/Flutter analyzer | bundled | errors, warnings, static types | Public |
| DCM | 1.40.4 | complexity/length metrics, unused code/files, dependencies, duplication, architecture rules | Free/Pro/Teams; Pro+ features and Teams+ CI require a license |
| Gitleaks | 8.30.1 | secret scanning in Git history | Open source |
| OSV-Scanner | 2.7.1 | dependency vulnerability scanning | Open source |
| Semgrep | 1.150.0 | Kotlin/Swift security rules | Open source; registry rules require network |
| SonarScanner CLI | 12.4.0.4321_8.4.0 | SonarQube analysis/coverage import | Server/edition required |
| SonarQube Server | 2026.5 LTA or later | centralized Dart quality analysis | Server + Dart support required |

### Compatibility notes

- `riverpod_lint` 3.2.0 uses the analyzer's `analysis_server_plugin` API. It is
  loaded from `analysis_options.yaml`; `custom_lint` is **not** used. The current
  `custom_lint` release targets analyzer 8.x, while Dart 3.14 provides analyzer
  14.x.
- DCM 1.40.4's public metric set does not include a cognitive-complexity metric.
  CallFilter configures cyclomatic complexity, nesting, parameter count,
  method/class size and coupling instead. This is a documented limitation, not
  a claim that cognitive complexity is analyzed.
- DCM Free includes `analyze`, `calculate-metrics`, `check-unused-files` and
  `analyze-structure` (within its LOC limit). `check-unused-code`,
  `check-dependencies` and `check-code-duplication` are Pro+ commands. Teams+
  is required for a CI key and GitLab-format reporters. The project configures
  both sets, but Pro+ reports are non-fatal until a baseline has been reviewed.
- Semgrep's Dart support is experimental and not part of the security gate.
  Semgrep is used for Kotlin and Swift; Dart is covered by the analyzer,
  riverpod_lint, Gitleaks, OSV-Scanner and the custom architecture test.
- SonarQube Server 2026.5 officially lists Dart. Its current documentation says
  Dart 3–3.13 is fully supported; this project uses Dart 3.14, so SonarQube may
  report incomplete results. Treat Sonar as optional until the server version
  and Dart support are verified for the exact release.

## Mandatory checks for a merge request

These checks are blocking in the pipeline when their infrastructure exists:

1. `dart format --output=none --set-exit-if-changed lib test integration_test`
2. `flutter analyze` (very_good_analysis + riverpod_lint)
3. Generated-code freshness: `flutter gen-l10n` + `dart run build_runner build`
   + `git diff --exit-code`
4. Unit tests, including the architecture dependency test
5. Widget tests
6. Gitleaks secret scan
7. OSV-Scanner dependency scan
8. Semgrep Kotlin/Swift security scan

DCM and SonarQube are conditional because they require a license/server. They
are not silently reported as successful: if their prerequisites are absent, the
jobs are not created. When `DCM_CI_KEY`/`DCM_EMAIL` exist, `analyze` and
complexity metrics are blocking; unused-code, dependency and duplication
reports are generated but non-fatal pending baseline review.

## Local commands

### Day-to-day quality gate

```bash
flutter pub get
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze
flutter test
```

Or use the wrapper:

```bash
./tool/quality/check.sh
```

### Generated code

```bash
flutter gen-l10n
dart run build_runner build
git diff --exit-code
```

Generated files are committed. CI checks them once in `generated_code`; other
jobs do not rerun `build_runner`.

### DCM

DCM is a non-destructive reporting tool in this project. The configuration is
in [`analysis_options.yaml`](../analysis_options.yaml); DCM is deliberately not
a `pubspec.yaml` dependency. Do not run `dcm fix` or delete code/files/dependencies
from a DCM finding without manual review.

#### Installation

Pin **1.40.4**. macOS:

```bash
brew tap CQLabs/dcm
brew trust CQLabs/dcm
brew install dcm@1.40.4
dcm --version
```

`tool/ci/install_dcm.sh` installs the pinned macOS x64/arm64 ZIP or Linux
`.deb` without root, verifying the published SHA-256:

```bash
source tool/ci/install_dcm.sh
dcm --version
```

The local binary does not bypass DCM activation; the current environment has no
license, so DCM reports cannot be generated.

Install the official DCM IDE plugin for VS Code or JetBrains and open this
project. The DCM CLI and the IDE plugin read the same `analysis_options.yaml`.
Follow the vendor installation guide: <https://dcm.dev/docs/getting-started/for-developers/installation/>.

#### License and plans

- **Free**: `analyze`, metrics, unused files, project structure, 50k LOC.
- **Pro+**: unused code, dependencies, duplication, rule configuration/presets.
- **Teams+**: CI key, GitLab/other integrations, dashboards and CLI fixes.

Use a legitimate local license for Pro+ work. CI reads `DCM_CI_KEY` and
`DCM_EMAIL` from GitLab CI/CD variables; never commit a key. The project uses a
Teams+ CI key only if the organization has one. The GitLab reporter is Teams+;
local runs default to the console reporter. Activity is disabled with
`--no-analytics`.

#### Commands

Wrapper (preferred):

```bash
./tool/quality/dcm.sh        # Free+: analyze, metrics, unused files, structure
./tool/quality/dcm.sh full   # also Pro+: unused code, dependencies, duplication
```

Underlying commands:

```bash
dcm analyze lib --fatal-warnings --no-analytics
dcm calculate-metrics lib --fatal-level=high --no-analytics
dcm check-unused-files lib --no-fatal-unused --no-analytics
dcm analyze-structure lib --no-analytics > reports/dcm-structure.dot

# Pro+ (requires a suitable local license)
dcm check-unused-code lib --exclude-public-api --no-fatal-unused --no-analytics
dcm check-dependencies lib --no-fatal-found --no-analytics
dcm check-code-duplication lib --no-fatal-found --no-analytics
```

Reports are written under `reports/` (gitignored): console logs, JSON reports
when `DCM_REPORTER` is set, and a GraphViz `.dot` dependency graph. Convert the
graph with `dot -Tpng reports/dcm-structure.dot -o reports/dcm-structure.png`.

`dcm analyze` and `calculate-metrics` are the mandatory checks when DCM runs.
Dead-code, dependency and duplication reports are initially non-fatal so a
baseline can be reviewed without hiding findings. `dcm --print-config` can show
the resolved configuration and any plan restrictions.

#### Configured rules and metrics

- Architecture boundaries via `avoid-banned-imports` for domain, data,
  presentation and core-outside-`di/` imports. These mirror
  `test/architecture/layer_dependencies_test.dart`; the custom test remains the
  portable gate.
- `avoid-unused-parameters`.
- Pubspec checks: `dependencies-ordering`, `pubspec-ordering`,
  `prefer-publish-to-none`, `prefer-semver-version`.
- Metrics: cyclomatic complexity 15, nesting 5, parameters 6, lines 100,
  source lines 80, weighted methods/class 80, methods 20, CBO 15, imports 25.
- `check-unused-code` is run with `--exclude-public-api` because this is an
  application; framework- and Riverpod-reached declarations must not be treated
  as dead public APIs. `check-unused-files` runs without that flag so unused
  files are still reported.
- Rule availability is plan-dependent. `dcm --print-config` reports unavailable
  rules/config keys; the custom architecture test remains the portable gate if
  the licensed plan does not include `avoid-banned-imports`.
- No cognitive-complexity metric is configured because DCM 1.40.4 does not
  expose it; cyclomatic complexity, nesting and size metrics are used instead.

#### Exclusions

Generated and test-only files are excluded per command:

- `**/*.g.dart`, `**/*.freezed.dart`, `**/*.mocks.dart`;
- `lib/l10n/gen/**` (generated localization);
- `test/**`, `integration_test/**`, `tool/**` for unused-code/file/duplication
  reports;
- tests are excluded from metrics;
- `lib/main.dart` is excluded from unused-files because Flutter invokes it
  without a Dart import.

Add an exclusion only when a concrete false positive is reproduced, and record
the file, rule/command and reason in this document. Do not exclude `lib/**` or
all generated-code-containing folders.

#### Reviewing findings

Classify every finding before changing code:

1. **Confirmed dead code** — no reference from Dart, routes, Riverpod, Drift
   registration, generated code or platform entrypoints.
2. **Probably unused** — only indirect/dynamic/framework references remain.
3. **False positive** — explain the mechanism and add a narrow exclusion.
4. **Manual review required** — architecture, generated-code interaction,
   cross-layer use or unclear ownership.

Providers, route paths, Drift tables/queries, Freezed/json factories and
generated registrations need explicit verification before removal. Never remove
a route handler merely because the path is a string literal, or a provider
merely because `ref` usage is indirect.

#### CI

The `code_metrics` job is created only when `DCM_CI_KEY` and `DCM_EMAIL` are
configured. It installs pinned DCM 1.40.4, runs
`DCM_REPORTER=gitlab ./tool/quality/dcm.sh full`, and stores
`reports/dcm-*` as artifacts. Analyze/metrics findings fail the job; Pro+ dead
code/dependency/duplication reports are report-only until the baseline is
accepted. CI never runs `dcm fix`.

### Gitleaks

Install the pinned binary and scan the working tree:

```bash
gitleaks dir . \
  --config .gitleaks.toml \
  --redact \
  --report-format sarif \
  --report-path reports/gitleaks.sarif \
  --verbose
```

To scan Git history:

```bash
gitleaks git --redact --report-format sarif --report-path reports/gitleaks.sarif .
```

The policy file extends the built-in rules. It contains path exclusions only for
build/dependency/generated directories, not for source findings. Add an allowlist
entry only for a confirmed false positive and document the file/rule/reason.

### OSV-Scanner

```bash
osv-scanner scan source \
  --lockfile=pubspec.lock \
  --format=table \
  .
```

CI writes `reports/osv.sarif`. The project currently has no other supported
lockfiles; if Gradle/SPM lockfiles or a backend lockfile are added, include them
in the scan.

### Semgrep

```bash
semgrep scan \
  --config p/security-audit \
  --config p/kotlin \
  --config p/swift \
  --metrics=off \
  --error \
  android/app/src/main/kotlin ios/Runner ios/CallDirectoryExtension
```

Semgrep 1.150.0 on macOS Intel prints harmless signal-handler warnings. CI uses
the pinned Semgrep container instead. Do not add Dart rules with unsupported
syntax merely to increase the rule count.

### Security wrapper

```bash
./tool/security/check.sh
```

It runs Gitleaks, OSV-Scanner and Semgrep and writes reports under `reports/`.
Install the required binaries on PATH first.

### SonarQube

Prerequisites:

- SonarQube Server 2026.5+ with Dart support, or a SonarQube Cloud project with
  the appropriate Dart capability;
- `SONAR_TOKEN` and `SONAR_HOST_URL` configured as masked/protected GitLab
  variables;
- coverage from `unit_tests` (`coverage/lcov.info`);
- a quality gate configured on the server.

Run locally:

```bash
export SONAR_HOST_URL=https://sonar.example.com
export SONAR_TOKEN=...
sonar-scanner -Dsonar.projectVersion=0.1.0
```

The properties file maps:

- `lib` as sources, `test`/`integration_test` as test sources;
- `sonar.dart.lcov.reportPaths=coverage/lcov.info`;
- generated/build/platform directories as exclusions;
- `sonar.qualitygate.wait=true`.

Do not put tokens in `sonar-project.properties` or any committed file.

## CI structure

```text
verify
  format
  analyze
  generated_code
  code_metrics      (only when DCM_CI_KEY/DCM_EMAIL exist; analyze/metrics blocking)
security
  secret_scan
  dependency_scan
  security_scan
test
  unit_tests        (coverage artifact)
  android_native_tests
  widget_tests
quality
  sonarqube         (only when SONAR_TOKEN/SONAR_HOST_URL exist)
build
  build_android_debug
ios
  build_ios_simulator
```

- Linux Flutter jobs install Flutter 3.50.0 from a SHA-256-pinned archive in
  `tool/ci/install_flutter_linux.sh`; they do not run `flutter upgrade`.
- Linux and macOS caches use different prefixes.
- Security reports are artifacts even when a scan fails, so reviewers can inspect
  the SARIF.
- Integration tests are not in the pipeline because no Android/iOS device runner
  is configured. Run them manually; see [testing.md](testing.md).

## Interpreting results

- **Analyzer/riverpod_lint**: fix errors and warnings. Do not suppress a rule
  globally without an explanatory comment. Prefer a targeted ignore with a
  reason.
- **DCM metrics**: high/very-high complexity or class size means split the
  declaration, not add an ignore. `dcm analyze` uses `--fatal-warnings`; style
  violations are not fatal by default. Dead-code/dependency/duplication reports
  are classified before any cleanup; do not run `dcm fix` in CI.
- **Gitleaks**: any finding is a potential credential incident. Do not disable
  the rule to get a green pipeline; remove the secret, rotate it if it was real,
  and only then add a narrow allowlist for a confirmed false positive.
- **OSV-Scanner**: review severity and reachability. Do not auto-update
  dependencies as part of the scan. Update a package deliberately, run the full
  test suite and record the change.
- **Semgrep**: Kotlin/Swift findings should be reviewed in context; the rules are
  not a proof of exploitability. Keep the target set limited to native code.
- **SonarQube**: the quality gate may fail on coverage/duplications. Check the
  server's Dart version support before treating missing Dart analysis as a
  scanner failure.
- Coverage currently comes from the `unit_tests` job. Widget tests run in a
  separate job and are not included in `coverage/lcov.info`; Sonar coverage is
  therefore partial and should not be read as whole-app coverage.
- SARIF reports are attached as generic artifacts. They are not transformed into
  GitLab's native SAST JSON schema; open the SARIF in an IDE/SARIF viewer or use
  the tool's console output.

## Exceptions and baselines

- Gitleaks: `.gitleaks.toml`; narrow regex/path and a comment.
- Semgrep: `.semgrepignore` for build/generated material; use a rule-level
  `nosemgrep` comment only with the finding reference and justification.
- Dart analyzer/riverpod_lint: `// ignore:` with a specific reason; prefer
  `// ignore_for_file:` only for generated or intentionally exceptional files.
- DCM: prefer fixing the metric; use `// ignore: type=metrics` only with a
  documented architectural reason.
- Sonar: configure exclusions for generated/build output only; do not exclude
  business logic to make a gate green.
- Do not add secrets to allowlists or test fixtures. Use obviously fake values
  and local-only files for any negative test.

## Updating tool versions

1. Check compatibility against the current Flutter/Dart SDK and lockfile.
2. Update the pinned image/archive version and SHA-256 in the same change.
3. Run the local checks and the affected native checks.
4. Update this document and the README if commands or prerequisites change.
5. Do not combine a tool upgrade with a runtime dependency upgrade unless the
   compatibility is explicitly tested.

## Required GitLab variables

| Variable | Used by | Secret |
| --- | --- | --- |
| `DCM_CI_KEY` | `code_metrics` | yes |
| `DCM_EMAIL` | `code_metrics` | no, but keep private |
| `SONAR_TOKEN` | `sonarqube` | yes |
| `SONAR_HOST_URL` | `sonarqube` | no |

`DCM_CI_KEY` and `SONAR_TOKEN` must be masked/protected as appropriate. None of
them belong in the repository.

## Known gaps

- The DCM 1.40.4 binary can be installed with `tool/ci/install_dcm.sh`, but DCM
  is not activated in this environment (no license key). Its YAML configuration
  is syntax-checked only; Free/Pro commands and reports have not been executed
  or baselined here.
- SonarQube has not been executed because no server/token is available. Dart
  3.14 is newer than the fully supported 3.13 range in the current Sonar docs.
- Semgrep covers Kotlin/Swift only; Dart is not in the security rule set.
- Semgrep's registry rules are fetched at run time and can change independently
  of the scanner version. For strict rule reproducibility, vendor/mirror the
  selected rules and update them through review.
- Integration tests require a device/emulator runner and are not a GitLab job.
- The architecture test checks imports, not runtime dependency graphs.
