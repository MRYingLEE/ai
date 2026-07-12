#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}"
DATAX_WORKSPACE_ROOT="${DATAX_WORKSPACE_ROOT:-$(cd "${REPO_ROOT}/.." && pwd)}"
DATAX_NOW_REPO_DIR="${DATAX_NOW_REPO_DIR:-${DATAX_WORKSPACE_ROOT}/datax_now}"
PUBLISH_WHEEL_SCRIPT="${DATAX_PUBLISH_WHEEL_SCRIPT:-${DATAX_NOW_REPO_DIR}/scripts/publish-wheel.sh}"
DEPLOY_BIN_DIR="${DATAX_NOW_REPO_DIR}/micromamba/envs/datax-now-deploy/bin"
NVM_NODE_BIN_DIR="${NVM_NODE_BIN_DIR:-${HOME}/.nvm/versions/node/v24.18.0/bin}"

usage() {
  cat <<'EOF'
Usage: ./local_build.sh [--no-publish] [--fast]

Build the jupyterlite_ai wheel with a clean frontend rebuild by default, then
publish it into datax_now/built-in-wheels when the downstream workspace is
available.
EOF
}

PUBLISH_AFTER_BUILD=true
CLEAN_FRONTEND=true
for arg in "$@"; do
  case "$arg" in
    --no-publish)
      PUBLISH_AFTER_BUILD=false
      ;;
    --fast|--no-clean)
      CLEAN_FRONTEND=false
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      usage >&2
      exit 1
      ;;
  esac
done

cd "$REPO_ROOT"

export PATH="${NVM_NODE_BIN_DIR}:${DEPLOY_BIN_DIR}:/usr/bin:/bin:${PATH}"

PYTHON_BIN="python3"
if [ -x "${DATAX_NOW_REPO_DIR}/micromamba/envs/datax-now-deploy/bin/python" ]; then
  PYTHON_BIN="${DATAX_NOW_REPO_DIR}/micromamba/envs/datax-now-deploy/bin/python"
fi

"${PYTHON_BIN}" -m pip install --quiet build hatchling hatch-jupyter-builder hatch-nodejs-version 2>/dev/null || true

if [ ! -d node_modules ]; then
  echo "Installing JavaScript dependencies..."
  npm install
else
  echo "JavaScript dependencies already present; skipping npm install"
fi

if [ "${CLEAN_FRONTEND}" = true ]; then
  echo "Cleaning generated frontend outputs..."
  npm run clean:all
fi

echo "Building frontend packages..."
npm run build:prod

echo "Building jupyterlite_ai wheel..."
rm -rf dist
mkdir -p dist
"${PYTHON_BIN}" -m build python/jupyterlite-ai --wheel --outdir dist

WHEEL="$(ls -t dist/jupyterlite_ai-*.whl | head -1)"
echo "Built: ${WHEEL}"

if [ "${PUBLISH_AFTER_BUILD}" = true ] && [ -f "${PUBLISH_WHEEL_SCRIPT}" ]; then
  "${PUBLISH_WHEEL_SCRIPT}" --package jupyterlite_ai "${WHEEL}"
else
  echo "Skipping downstream publish"
fi
