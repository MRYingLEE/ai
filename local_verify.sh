#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}"
DATAX_WORKSPACE_ROOT="${DATAX_WORKSPACE_ROOT:-$(cd "${REPO_ROOT}/.." && pwd)}"
DATAX_NOW_REPO_DIR="${DATAX_NOW_REPO_DIR:-${DATAX_WORKSPACE_ROOT}/datax_now}"
PUBLISH_WHEEL_SCRIPT="${DATAX_PUBLISH_WHEEL_SCRIPT:-${DATAX_NOW_REPO_DIR}/scripts/publish-wheel.sh}"

WHEEL="$(ls -t "${REPO_ROOT}"/dist/jupyterlite_ai-*.whl 2>/dev/null | head -1 || true)"
if [ -z "${WHEEL}" ]; then
  echo "ERROR: no jupyterlite_ai wheel found in ${REPO_ROOT}/dist" >&2
  exit 1
fi

if [ ! -f "${PUBLISH_WHEEL_SCRIPT}" ]; then
  echo "ERROR: publish helper not found: ${PUBLISH_WHEEL_SCRIPT}" >&2
  exit 1
fi

python3 "${DATAX_NOW_REPO_DIR}/built-in-wheels/update_wheel_references.py" --package jupyterlite_ai --validate-only
"${PUBLISH_WHEEL_SCRIPT}" --package jupyterlite_ai --validate-only "${WHEEL}"
echo "✓ Verified downstream pin for $(basename "${WHEEL}")"
