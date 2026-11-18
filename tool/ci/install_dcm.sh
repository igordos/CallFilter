#!/usr/bin/env bash
# Install a pinned DCM 1.40.4 macOS/Linux binary without requiring root.
# DCM itself still requires DCM_CI_KEY and DCM_EMAIL for licensed CI analysis.
set -euo pipefail

DCM_VERSION="${DCM_VERSION:-1.40.4}"
DCM_ARCH="${DCM_ARCH:-amd64}"
DCM_DEB_SHA256="${DCM_DEB_SHA256:-5e94309913eeddba84c410e04e2eb0842ed20d16e760e35f873a9c774db654b1}"
CI_ROOT="${CI_PROJECT_DIR:-$(pwd)}"
INSTALL_ROOT="$CI_ROOT/.ci/dcm-${DCM_VERSION}"

hash_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    shasum -a 256 "$1" | awk '{print $1}'
  fi
}

if [[ "$(uname -s)" == "Darwin" ]]; then
  case "$(uname -m)" in
    x86_64) DCM_MAC_ARCH="x64"; DCM_ZIP_SHA256="${DCM_MAC_X64_SHA256:-60db06c895ee2940fe0051b08f1be7d112e3ecef8a9228f0ff15601327a633ef}" ;;
    arm64) DCM_MAC_ARCH="arm"; DCM_ZIP_SHA256="${DCM_MAC_ARM_SHA256:-3e70c1f3a5e825211e547c2a413695bf7ac25ec8ab645731933ebc62be3e9c4d}" ;;
    *) echo "Unsupported macOS architecture: $(uname -m)" >&2; exit 1 ;;
  esac
  if [[ ! -x "$INSTALL_ROOT/bin/dcm" ]]; then
    mkdir -p "$CI_ROOT/.ci" "$INSTALL_ROOT/bin"
    work_dir="$(mktemp -d)"
    trap 'rm -rf "$work_dir"' EXIT
    zip="$work_dir/dcm.zip"
    curl --fail --location --retry 3 \
      "https://github.com/CQLabs/homebrew-dcm/releases/download/${DCM_VERSION}/dcm-macos-${DCM_MAC_ARCH}-release.zip" \
      --output "$zip"
    actual="$(hash_file "$zip")"
    if [[ "$actual" != "$DCM_ZIP_SHA256" ]]; then
      echo "DCM checksum mismatch: expected $DCM_ZIP_SHA256, got $actual" >&2
      exit 1
    fi
    unzip -oq "$zip" -d "$work_dir/unpacked"
    install -m 0755 "$work_dir/unpacked/dcm" "$INSTALL_ROOT/bin/dcm"
  fi
  export PATH="$INSTALL_ROOT/bin:$PATH"
else
  if [[ ! -x "$INSTALL_ROOT/usr/bin/dcm" ]]; then
    mkdir -p "$CI_ROOT/.ci"
    work_dir="$(mktemp -d)"
    trap 'rm -rf "$work_dir"' EXIT
    deb="$work_dir/dcm_${DCM_VERSION}-1_${DCM_ARCH}.deb"

    curl --fail --location --retry 3 \
      "https://github.com/CQLabs/homebrew-dcm/releases/download/${DCM_VERSION}/dcm_${DCM_VERSION}-1_${DCM_ARCH}.deb" \
      --output "$deb"
    actual="$(hash_file "$deb")"
    if [[ "$actual" != "$DCM_DEB_SHA256" ]]; then
      echo "DCM checksum mismatch: expected $DCM_DEB_SHA256, got $actual" >&2
      exit 1
    fi
    mkdir -p "$INSTALL_ROOT"
    dpkg-deb --extract "$deb" "$INSTALL_ROOT"
  fi
  export PATH="$INSTALL_ROOT/usr/bin:$PATH"
fi

dcm --version
