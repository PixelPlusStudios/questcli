#!/usr/bin/env bash
# Builds a standalone quest binary + assets for the current platform (macOS or Linux).
# Uses `dart build cli` (required when using sqlite3 with build hooks).
# Output: release/quest-<version>-<os>-<arch>.zip
# Note: First build needs network so sqlite3 can fetch native libs.
set -e
cd "$(dirname "$0")/.."

VERSION="${VERSION:-$(grep '^version:' pubspec.yaml | sed 's/version: *//' | tr -d ' \r')}"
OS=$(uname -s)
case "$OS" in
  Darwin)  OS=darwin ;;
  Linux)   OS=linux ;;
  *)       echo "Unsupported OS: $OS"; exit 1 ;;
esac
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)  ARCH=amd64 ;;
  aarch64|arm64) ARCH=arm64 ;;
  *)       ARCH="$ARCH" ;;
esac

echo "Building quest $VERSION for $OS-$ARCH..."
dart build cli -o build

# dart build cli puts bundle in build/bundle/ with bin/<exe> and lib/
# Rename the bin exe to "quest", then copy bin/, lib/, and our assets into the stage
EXE=$(find build/bundle/bin -maxdepth 1 -type f 2>/dev/null | head -1)
if [ -n "$EXE" ] && [ "$(basename "$EXE")" != "quest" ]; then
  mv "$EXE" build/bundle/bin/quest
fi

STAGE="quest-${VERSION}-${OS}-${ARCH}"
mkdir -p "release/$STAGE"
cp -r build/bundle/bin "release/$STAGE/"
cp -r build/bundle/lib "release/$STAGE/" 2>/dev/null || true
cp -r assets "release/$STAGE/"
find "release/$STAGE" -name .DS_Store -delete 2>/dev/null || true

cd release
zip -r "${STAGE}.zip" "$STAGE"
cd ..

echo "Built release/${STAGE}.zip"
