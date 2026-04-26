#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing package in development mode..."
pip install -e "."

echo "==> Linking extension with JupyterLab..."
jupyter labextension develop . --overwrite

echo "==> Building extension..."
jlpm build

echo "==> Applying settings overrides..."
OVERRIDES_DIR=$(jupyter --data-dir)/lab/settings
mkdir -p "$OVERRIDES_DIR"
cp demo/overrides.json "$OVERRIDES_DIR/overrides.json"

echo "==> Starting JupyterLab..."
jupyter lab
