#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-}"
USERNAME="${2:-vlv}"
PROJECT_NAME="${3:-lockapp-vlv}"
if [[ -z "$VERSION" ]]; then
  echo "Usage: ./scripts/publish-sourceforge.sh <version> [username] [project-name]" >&2
  exit 64
fi

PRODUCT_NAME="LockApp-vlv"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCEFORGE_DIR="$ROOT_DIR/dist/sourceforge/v$VERSION"
ZIP_NAME="$PRODUCT_NAME-$VERSION-macos-unsigned.zip"
REMOTE_HOST="frs.sourceforge.net"
REMOTE_DIR="/home/frs/project/${PROJECT_NAME}/v${VERSION}"

if [[ ! -d "$SOURCEFORGE_DIR" ]]; then
  "$ROOT_DIR/scripts/prepare-sourceforge-release.sh" "$VERSION"
fi

if [[ ! -f "$SOURCEFORGE_DIR/$ZIP_NAME" || ! -f "$SOURCEFORGE_DIR/$ZIP_NAME.sha256" ]]; then
  echo "Missing SourceForge release files in $SOURCEFORGE_DIR" >&2
  exit 66
fi

ssh "${USERNAME}@${REMOTE_HOST}" "mkdir -p '$REMOTE_DIR'"
scp "$SOURCEFORGE_DIR/$ZIP_NAME" "$SOURCEFORGE_DIR/$ZIP_NAME.sha256" "$SOURCEFORGE_DIR/README-v$VERSION.md" "${USERNAME}@${REMOTE_HOST}:$REMOTE_DIR/"

echo "Uploaded SourceForge files to $REMOTE_DIR"
