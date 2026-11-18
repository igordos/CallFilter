#!/usr/bin/env bash
# Non-destructive DCM report runner.
#
# Usage:
#   ./tool/quality/dcm.sh          # Free+: analyze, metrics, unused files, structure
#   ./tool/quality/dcm.sh full     # also Pro+: unused code, dependencies, duplication
#
# Optional environment:
#   DCM_REPORTER=console|gitlab|json|sonar|checkstyle|codeclimate
#   DCM_CI_KEY / DCM_EMAIL are read by DCM for licensed CI runs.
#
# This script never invokes `dcm fix`: findings must be reviewed manually.
set -euo pipefail

cd "$(dirname "$0")/../.."

MODE="${1:-free}"
REPORTER="${DCM_REPORTER:-console}"

case "$MODE" in
  free|full) ;;
  *)
    echo "Usage: $0 [free|full]" >&2
    exit 2
    ;;
esac

if ! command -v dcm >/dev/null 2>&1; then
  cat >&2 <<'EOF'
DCM CLI is not installed.
Install the pinned version from https://dcm.dev/docs/getting-started/for-developers/installation/
  macOS: brew tap CQLabs/dcm && brew trust CQLabs/dcm && brew install dcm@1.40.4
  macOS/Linux: source tool/ci/install_dcm.sh
Then run `dcm --version` and re-run this script.
EOF
  exit 127
fi

dcm --version
mkdir -p reports

run() {
  local name="$1"
  shift
  if [[ "$REPORTER" == "console" ]]; then
    "$@" --no-analytics 2>&1 | tee "reports/dcm-${name}.log"
  else
    "$@" --no-analytics --reporter="$REPORTER" \
      --output-to="reports/dcm-${name}.json"
  fi
}

# Free+ checks. Analyze and metrics are the blocking quality gate when DCM is
# licensed and available. Unused files are report-only until a baseline exists.
run analyze dcm analyze lib --fatal-warnings
run metrics dcm calculate-metrics lib --fatal-level=high
run unused-files dcm check-unused-files lib --no-fatal-unused
dcm analyze-structure lib --no-analytics >reports/dcm-structure.dot

if [[ "$MODE" == "full" ]]; then
  # Pro+ commands. They are intentionally report-only: a new finding must be
  # classified as dead code, likely dead code, false positive or manual review
  # before any deletion or dependency change.
  run unused-code dcm check-unused-code lib --exclude-public-api --no-fatal-unused
  run dependencies dcm check-dependencies lib --no-fatal-found
  run duplication dcm check-code-duplication lib --no-fatal-found
fi

echo "DCM reports written to reports/."
