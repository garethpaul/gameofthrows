#!/bin/sh

set -eu

function ci_lib() {
    NAME=$1
    xcodebuild -project GameOfThrows.xcodeproj \
               -scheme "GameOfThrowsUITests" \
               -destination "platform=iOS Simulator,name=${NAME}" \
               -sdk iphonesimulator \
               -configuration "Debug" \
               test
}
ci_lib "iPhone 5"
