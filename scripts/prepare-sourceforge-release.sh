#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
  echo "Usage: ./scripts/prepare-sourceforge-release.sh <version>" >&2
  exit 64
fi

PRODUCT_NAME="LockApp-vlv"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
SOURCEFORGE_DIR="$DIST_DIR/sourceforge/v$VERSION"
ZIP_NAME="$PRODUCT_NAME-$VERSION-macos-unsigned.zip"

cd "$ROOT_DIR"

if [[ ! -f "$DIST_DIR/$ZIP_NAME" || ! -f "$DIST_DIR/$ZIP_NAME.sha256" ]]; then
  "$ROOT_DIR/scripts/package-release.sh" "$VERSION"
fi

rm -rf "$SOURCEFORGE_DIR"
mkdir -p "$SOURCEFORGE_DIR"
cp "$DIST_DIR/$ZIP_NAME" "$SOURCEFORGE_DIR/$ZIP_NAME"
cp "$DIST_DIR/$ZIP_NAME.sha256" "$SOURCEFORGE_DIR/$ZIP_NAME.sha256"
cp "$ROOT_DIR/.github/release-notes/v$VERSION.md" "$SOURCEFORGE_DIR/README-v$VERSION.md"

echo "Prepared $SOURCEFORGE_DIR"
echo "Upload with: ./scripts/publish-sourceforge.sh $VERSION vlv lockapp-vlv"
