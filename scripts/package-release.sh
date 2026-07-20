#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
  echo "Usage: ./scripts/package-release.sh <version>" >&2
  exit 64
fi

APP_NAME="Lockapp-vlv"
PRODUCT_NAME="LockApp-vlv"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
ZIP_NAME="$PRODUCT_NAME-$VERSION-macos-unsigned.zip"
ZIP_PATH="$DIST_DIR/$ZIP_NAME"

cd "$ROOT_DIR"

"$ROOT_DIR/scripts/package-app.sh" "$VERSION"

rm -f "$ZIP_PATH" "$ZIP_PATH.sha256"
(
  cd "$DIST_DIR"
  /usr/bin/ditto -c -k --sequesterRsrc --keepParent "$APP_NAME.app" "$ZIP_NAME"
  shasum -a 256 "$ZIP_NAME" > "$ZIP_NAME.sha256"
)

echo "Created $ZIP_PATH"
echo "Created $ZIP_PATH.sha256"
echo "Release build: ad-hoc signed only. No Developer ID. Not notarized."
