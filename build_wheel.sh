#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing dependencies..."
pip install build

echo "==> Cleaning previous builds..."
rm -rf dist/

echo "==> Building wheel..."
python -m build --wheel

echo "==> Done. Wheel file:"
ls dist/*.whl
