#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
test_root=$(mktemp -d "${TMPDIR:-/tmp}/gameofthrows-hosted-runner-test.XXXXXX")
trap 'rm -rf -- "$test_root"' EXIT HUP INT TERM

mkdir -p "$test_root/bin"

cat >"$test_root/bin/xcrun" <<'EOF'
#!/bin/sh
set -eu
printf '%s\n' "$*" >>"$XCRUN_LOG"
if [ "${1-} ${2-}" = "simctl create" ]; then
  printf '%s\n' "TEST-DEVICE-ID"
fi
EOF

cat >"$test_root/bin/xcodebuild" <<'EOF'
#!/bin/sh
set -eu
printf '%s\n' "$*" >>"$XCODEBUILD_LOG"
exit "${XCODEBUILD_EXIT:-0}"
EOF

chmod +x "$test_root/bin/xcrun" "$test_root/bin/xcodebuild"

run_runner() {
  XCRUN_LOG="$test_root/xcrun.log" \
  XCODEBUILD_LOG="$test_root/xcodebuild.log" \
  TMPDIR="$test_root" \
  PATH="$test_root/bin:$PATH" \
  XCODEBUILD_EXIT="${1:-0}" \
    "$ROOT_DIR/scripts/run-hosted-ui-test.sh"
}

assert_lifecycle() {
  normalized=$(sed -E 's/GameOfThrows-CI-[0-9]+/GameOfThrows-CI-PID/' "$test_root/xcrun.log")
  expected=$(cat <<'EOF'
simctl create GameOfThrows-CI-PID com.apple.CoreSimulator.SimDeviceType.iPhone-16-Pro com.apple.CoreSimulator.SimRuntime.iOS-18-5
simctl boot TEST-DEVICE-ID
simctl bootstatus TEST-DEVICE-ID -b
simctl shutdown TEST-DEVICE-ID
simctl delete TEST-DEVICE-ID
EOF
)
  if [ "$normalized" != "$expected" ]; then
    printf '%s\n' "Hosted UI runner must create, boot, await, and delete its simulator." >&2
    exit 1
  fi
  if ! grep -Fq -- '-destination platform=iOS Simulator,id=TEST-DEVICE-ID' "$test_root/xcodebuild.log"; then
    printf '%s\n' "Hosted UI runner must bind XCTest to the disposable simulator UDID." >&2
    exit 1
  fi
}

: >"$test_root/xcrun.log"
: >"$test_root/xcodebuild.log"
run_runner
assert_lifecycle

: >"$test_root/xcrun.log"
: >"$test_root/xcodebuild.log"
if run_runner 65; then
  printf '%s\n' "Hosted UI runner must propagate xcodebuild failures." >&2
  exit 1
fi
assert_lifecycle

printf '%s\n' "Hosted UI runner lifecycle checks passed."
