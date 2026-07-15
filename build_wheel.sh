#!/usr/bin/env bash
set -euo pipefail

echo "build_wheel.sh is deprecated; use ./local_build.sh instead." >&2
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/local_build.sh" "$@"
