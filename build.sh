#!/bin/sh
set -eu

PROJECT=${XCODE_PROJECT:-GameOfThrows.xcodeproj}
SCHEME=${XCODE_SCHEME:-GameOfThrowsUITests}
SIMULATOR_NAME=${IOS_SIMULATOR_NAME:-iPhone 5}
DESTINATION=${IOS_DESTINATION:-platform=iOS Simulator,name=${SIMULATOR_NAME}}
CONFIGURATION=${CONFIGURATION:-Debug}

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
  test
