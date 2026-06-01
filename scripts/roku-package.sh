#!/usr/bin/env bash
# Package the BSC-transpiled output (build/staging) so that .bs (BrighterScript)
# files become .brs before shipping. Roku devices only read .brs — never .bs.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STAGING="$ROOT/build/staging"
OUT_DIR="$ROOT/out"
ZIP_NAME="roku-tv-learning.zip"

if [[ ! -d "$STAGING" ]]; then
    echo "staging dir not found at $STAGING — run bsc first (npm run build)"
    exit 1
fi
if [[ ! -f "$STAGING/manifest" ]]; then
    echo "manifest not found at $STAGING/manifest"
    exit 1
fi

mkdir -p "$OUT_DIR"
rm -f "$OUT_DIR/$ZIP_NAME"

cd "$STAGING"
zip -r "$OUT_DIR/$ZIP_NAME" . \
    -x "*.DS_Store"

echo "Packaged: $OUT_DIR/$ZIP_NAME"
