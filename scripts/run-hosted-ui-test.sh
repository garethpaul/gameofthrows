#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
simulator_name="GameOfThrows-CI-$$"
device_type="com.apple.CoreSimulator.SimDeviceType.iPhone-16-Pro"
runtime="com.apple.CoreSimulator.SimRuntime.iOS-18-5"
simulator_id=$(xcrun simctl create "$simulator_name" "$device_type" "$runtime")

cleanup() {
  xcrun simctl shutdown "$simulator_id" >/dev/null 2>&1 || true
  xcrun simctl delete "$simulator_id" >/dev/null 2>&1 || true
}
trap cleanup EXIT

xcrun simctl boot "$simulator_id"
xcrun simctl bootstatus "$simulator_id" -b
IOS_DESTINATION="platform=iOS Simulator,id=$simulator_id" "$ROOT_DIR/build.sh"
