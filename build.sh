#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DEFAULT_PROJECT="$ROOT_DIR/GameOfThrows.xcodeproj"
PROJECT=${XCODE_PROJECT:-$DEFAULT_PROJECT}
SCHEME=${XCODE_SCHEME:-GameOfThrowsUITests}
SIMULATOR_NAME=${IOS_SIMULATOR_NAME:-iPhone 5}
DESTINATION=${IOS_DESTINATION:-platform=iOS Simulator,name=${SIMULATOR_NAME}}
CONFIGURATION=${CONFIGURATION:-Debug}
derived_data=$(mktemp -d "${TMPDIR:-/tmp}/gameofthrows-test-derived-data.XXXXXX")
trap 'rm -rf -- "$derived_data"' EXIT HUP INT TERM

if ! command -v xcodebuild >/dev/null 2>&1; then
  printf '%s\n' "xcodebuild is required to run the GameOfThrows Xcode test target." >&2
  exit 127
fi

xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "$DESTINATION" \
  -sdk iphonesimulator \
  -configuration "$CONFIGURATION" \
  -derivedDataPath "$derived_data" \
  test
