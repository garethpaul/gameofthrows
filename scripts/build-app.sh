#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
derived_data=$(mktemp -d "${TMPDIR:-/tmp}/gameofthrows-derived-data.XXXXXX")
trap 'rm -rf -- "$derived_data"' EXIT HUP INT TERM

xcodebuild \
  -project "$ROOT_DIR/GameOfThrows.xcodeproj" \
  -scheme GameOfThrows \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath "$derived_data" \
  CODE_SIGNING_ALLOWED=NO \
  build
