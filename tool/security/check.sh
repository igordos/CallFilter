#!/usr/bin/env bash
# Local security scans. Tools are expected on PATH at the versions documented
# in docs/code-quality.md. Reports are written to reports/.
set -euo pipefail

cd "$(dirname "$0")/../.."
mkdir -p reports

gitleaks dir . \
  --config .gitleaks.toml \
  --redact \
  --no-banner \
  --max-target-megabytes=10 \
  --report-format sarif \
  --report-path reports/gitleaks.sarif \
  --verbose

osv-scanner scan source \
  --lockfile=pubspec.lock \
  --format=sarif \
  --output-file=reports/osv.sarif \
  .

semgrep scan \
  --config p/security-audit \
  --config p/kotlin \
  --config p/swift \
  --metrics=off \
  --disable-version-check \
  --error \
  --sarif \
  --output=reports/semgrep.sarif \
  android/app/src/main/kotlin ios/Runner ios/CallDirectoryExtension
