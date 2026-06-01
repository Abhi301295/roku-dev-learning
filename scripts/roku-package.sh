#!/usr/bin/env bash
# Same approach as lg-samsung-tv-player-lg-dev/scripts/roku-package.sh:
# zip the project source tree directly (not bsc staging). BRS reads this format.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="$ROOT/out"
ZIP_NAME="roku-tv-learning.zip"

if [[ ! -f "$ROOT/manifest" ]]; then
    echo "manifest not found at $ROOT/manifest"
    exit 1
fi

mkdir -p "$OUT_DIR"
rm -f "$OUT_DIR/$ZIP_NAME"

cd "$ROOT"
zip -r "$OUT_DIR/$ZIP_NAME" . \
    -x "*.DS_Store" \
    -x ".git/*" \
    -x ".vscode/*" \
    -x "bsconfig.json" \
    -x "package.json" \
    -x "package-lock.json" \
    -x "node_modules/*" \
    -x "build/*" \
    -x "out/*" \
    -x "scripts/*" \
    -x ".gitignore" \
    -x "*.md"

echo "Packaged: $OUT_DIR/$ZIP_NAME"
