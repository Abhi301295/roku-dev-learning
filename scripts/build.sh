#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> BrightScript validate (bsc)"
cd "$ROOT"
bsc

echo "==> Package channel zip"
bash "$ROOT/scripts/roku-package.sh"
