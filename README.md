# CallFilter

CallFilter is a local-first Flutter app for reducing unwanted phone calls by
matching **the caller's organization display name**, not only a specific phone
number. Rules, whitelist entries, settings and the blocked-call log stay on the
device.

The project is an initial production-oriented foundation: the app builds and
runs, the rule engine is tested, and native integration points are in place.
Platform call blocking still has to be validated on physical devices. Read
[platform limitations](docs/platform-limitations.md) before describing it as a
working system-level blocker.

## Features

- Create, edit, enable/disable and delete organization-name RegExp rules.
- Priority ordering when several rules match.
- Whitelist precedence by digits-only phone comparison.
- Locally stored blocked-call history.
- Filtering and history logging settings.
- Light, dark and system themes with persisted user selection.
- English and Russian UI localization.
- Material 3 Expressive design system with custom cobalt/teal tokens and components.
- Rule and whitelist search, date-grouped blocked-call history.
- Local caller check that exercises the real filter engine and records a
  blocked call in history.
- Android `CallScreeningService` bridge and a prepared Call Directory Extension
  source for iOS.
- Riverpod-only dependency injection, GoRouter navigation and Drift/SQLite
  persistence.

## Verified environment

The repository was implemented and verified with:

- Flutter 3.50.0 stable, Dart 3.14.0
- Riverpod 3.5.0, GoRouter 18.1.4, Drift 2.35.4
- Android SDK 36, AGP 9.3.1, Gradle 9.5.0, JDK 17
- Xcode 26.3, iOS Simulator runtime 26.3
- macOS

The Flutter test suite, Android JUnit tests, Xcode `RunnerTests`, Android debug
APK build, iOS simulator build and the integration suite (rules, whitelist,
language, theme persistence) were executed successfully in this environment.

Flutter 3.50 uses the extracted Material package. Dart imports must use
`package:material_ui/material_ui.dart`, not `package:flutter/material.dart`.

## Requirements

- Flutter 3.50.0 or a compatible newer stable release
- Dart 3.14.0+
- Android SDK with API 36 for Android builds
- JDK 17+ for Android builds
- Xcode 26+ and CocoaPods only if you maintain the iOS target locally

## Quick start

```bash
flutter --version
flutter pub get
flutter gen-l10n
dart run build_runner build
flutter run
```

Code generation is required after changing Drift tables, Freezed models or
localization ARB files. Generated files are checked in so a fresh clone can be
analyzed without running the generators first.

## Quality commands

```bash
./tool/quality/check.sh

# Equivalent individual checks
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze
flutter test

# DCM report (Free+ commands; `full` adds Pro+ dead-code/dependency/duplication)
./tool/quality/dcm.sh
./tool/quality/dcm.sh full

# Android native unit tests
(cd android && ./gradlew testDebugUnitTest)

# iOS build and native tests (macOS only)
flutter build ios --simulator --no-codesign
xcodebuild test \
  -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -only-testing:RunnerTests
```

Security checks are documented in [docs/code-quality.md](docs/code-quality.md).
Gitleaks, OSV-Scanner and Semgrep can be run together with:

```bash
./tool/security/check.sh
```

DCM and SonarQube are infrastructure-backed checks; see the same document for
free/Pro/Teams licensing and server prerequisites. No secrets belong in the
repository.

Integration tests require a running device or simulator:

```bash
flutter test integration_test/app_flow_test.dart -d <device-id>
flutter test integration_test/persistence_test.dart -d <device-id>
```

## Builds

```bash
flutter build apk --debug
flutter build ios --simulator --no-codesign
```

## Project layout

```text
lib/
  app/                    MaterialApp, GoRouter, app shell, theme
  core/                   database, DI, errors, logging, regex factory, IDs
  features/
    call_filter/          engine, regex safety, platform gateway, snapshot
    call_history/         blocked-call model, repository, UI
    contacts/             whitelist model, repository, UI
    home/                 dashboard and caller-check entry point
    rules/                rules model, repository, controllers, editor/list
    settings/             local settings, platform capabilities, UI
  l10n/                   English/Russian ARB files and generated classes
  shared/                 reusable widgets
.agents/skills/           installed and project AI Agent Skills
test/                     unit and widget tests
integration_test/         on-device flows and database persistence
android/                  Kotlin MethodChannel + CallScreeningService + JUnit
ios/                      Swift MethodChannel, snapshot parser, extension source
docs/                     architecture, design system, quality, platform limits, testing
```

## Platform integration in one paragraph

Android can screen calls only after the user grants the call screening role. The
service may receive a caller display name, but Android does not guarantee it and
the name presentation can be restricted. iOS never exposes an arbitrary caller
name to third-party apps at call time; a Call Directory Extension can only use
prepared number-to-label/block mappings. Therefore the shared RegExp engine is
used by the app and by Android's native matcher, while iOS consumes prepared
mappings only. Details and a release checklist are in
[docs/platform-limitations.md](docs/platform-limitations.md).

## Android setup

The manifest declares `CallFilterScreeningService`. On Android 10+, grant the
call screening role from the app's Settings screen ("Open system settings") or
from system settings. The role and service binding were exercised on a physical
Samsung SM-S928B: unknown callers reached `CallFilterScreeningService`, while
stored-contact calls were routed to Samsung's own service. End-to-end rejection
of a real call has **not** been proven; do not describe contact-name blocking as
working on that device.

## iOS setup

The iOS host app builds and its snapshot parser is covered by Swift Testing. The
`ios/CallDirectoryExtension` source and `Info.plist` are provided, but adding the
Call Directory Extension target and App Group capability requires Xcode manual
setup. Without that target, no iOS call directory data is applied. See the
platform limitations document for the exact checklist.

## CI

`.gitlab-ci.yml` defines six stages:

1. `verify` — format, analyzer/riverpod_lint, generated-code freshness, DCM
2. `security` — Gitleaks, OSV-Scanner, Semgrep
3. `test` — unit/architecture/repository tests, Android JUnit tests and widget tests
4. `quality` — SonarQube when server/token variables are configured
5. `build` — Android debug APK
6. `ios` — iOS simulator build on a macOS-tagged runner

Linux Flutter jobs install the SHA-256-pinned Flutter 3.50.0 archive; they never
run `flutter upgrade`. DCM is conditional on `DCM_CI_KEY`/`DCM_EMAIL` (Teams+);
when configured, `analyze` and metrics are blocking while dead-code/dependency/
duplication reports remain non-fatal until baselined. SonarQube is conditional on
`SONAR_TOKEN` and `SONAR_HOST_URL`. The macOS runner must provide
Flutter 3.50.0 and Xcode. No publishing, signing or store deployment is
configured.

## Documentation

- [Architecture](docs/architecture.md)
- [Design system](docs/design-system.md)
- [Code quality and security](docs/code-quality.md)
- [AI-assisted development](docs/ai-development.md)
- [Platform limitations](docs/platform-limitations.md)
- [Testing conventions](docs/testing.md)
- [Instructions for AI coding agents](AGENTS.md)

## Known limitations

- Application/bundle identifiers use the placeholder `com.callfilter.*`; replace
  them with the publisher's identifier before release.

- Real incoming-call history from native callbacks is not wired back into the
  Flutter database yet. The in-app caller check records history; the native
  service currently rejects calls without creating a Flutter history row.
- iOS Call Directory Extension target/App Group setup is documented but not
  automated in the Xcode project.
- Android caller-name availability depends on the device, carrier and system
  presentation rules.
- The Dart RegExp engine has no matching timeout; CallFilter uses static
  validation plus a killable isolate with a timeout. Android native matching
  has static checks only.
- The UI uses a custom Material 3 Expressive design system; golden images are
  generated locally on macOS and are not the cross-platform CI gate.
- No backend, authentication, analytics or cloud services are used.
- DCM 1.40.4 can be installed with `tool/ci/install_dcm.sh`, but local
  activation is not configured; no DCM report or baseline has been measured yet.
- SonarQube requires a server/token and its Dart 3.14 support is not yet listed
  as fully supported by SonarQube Server 2026.5.
