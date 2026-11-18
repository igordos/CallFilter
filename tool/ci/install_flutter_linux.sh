#!/usr/bin/env bash
# Install the exact Flutter version used by the project on a Linux CI runner.
#
# The archive and SHA-256 are pinned so the pipeline cannot silently float to a
# different Flutter/Dart release. If the runner already provides a verified SDK,
# set FLUTTER_BIN to its flutter executable to skip the download.
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-3.50.0}"
FLUTTER_ARCHIVE="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
FLUTTER_SHA256="${FLUTTER_SHA256:-6ea2d806fd57269ae783e6788e2a81fc26eaad782f1e0d0ff38623bb765ff9f5}"
CI_ROOT="${CI_PROJECT_DIR:-$(pwd)}"
INSTALL_ROOT="$CI_ROOT/.ci/flutter-${FLUTTER_VERSION}"

if [[ -n "${FLUTTER_BIN:-}" ]]; then
  FLUTTER_BIN="$(command -v "$FLUTTER_BIN")"
  export PATH="$(dirname "$FLUTTER_BIN"):$PATH"
else
  if [[ ! -x "$INSTALL_ROOT/bin/flutter" ]]; then
    mkdir -p "$CI_ROOT/.ci"
    work_dir="$(mktemp -d)"
    trap 'rm -rf "$work_dir"' EXIT
    archive="$work_dir/$FLUTTER_ARCHIVE"

    curl --fail --location --retry 3 \
      "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/$FLUTTER_ARCHIVE" \
      --output "$archive"
    echo "$FLUTTER_SHA256  $archive" | sha256sum --check --status -
    tar -xJf "$archive" -C "$CI_ROOT/.ci"
    rm -rf "$INSTALL_ROOT"
    mv "$CI_ROOT/.ci/flutter" "$INSTALL_ROOT"
  fi
  export PATH="$INSTALL_ROOT/bin:$PATH"
fi

if ! flutter --version | grep -q "Flutter $FLUTTER_VERSION"; then
  echo "Expected Flutter $FLUTTER_VERSION, got:" >&2
  flutter --version >&2 || true
  exit 1
fi
flutter --version
