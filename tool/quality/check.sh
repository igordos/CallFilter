#!/usr/bin/env bash
# Local pre-MR quality gate. Requires the project's pinned Flutter SDK.
set -euo pipefail

cd "$(dirname "$0")/../.."

flutter pub get
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze
flutter test
