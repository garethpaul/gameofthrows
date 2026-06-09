#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PLAN="$ROOT_DIR/docs/plans/2026-06-08-gameofthrows-spritekit-baseline.md"
SCORE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-score-contact-idempotency.md"

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file missing: $path" >&2
    exit 1
  fi
}

for path in \
  ".gitignore" \
  "CHANGES.md" \
  "Makefile" \
  "README.md" \
  "SECURITY.md" \
  "VISION.md" \
  "build.sh" \
  "GameOfThrows/Info.plist" \
  "GameOfThrows.xcodeproj/project.pbxproj" \
  "GameOfThrows/GameScene.swift" \
  "GameOfThrows/GameViewController.swift" \
  "GameOfThrows/AppDelegate.swift" \
  "GameOfThrowsUITests/Info.plist" \
  "GameOfThrowsUITests/GameOfThrowsUITests.swift" \
  "docs/plans/2026-06-08-gameofthrows-spritekit-baseline.md" \
  "docs/plans/2026-06-09-score-contact-idempotency.md"; do
  require_file "$path"
done

sh -n "$ROOT_DIR/build.sh"
sh -n "$ROOT_DIR/scripts/check-baseline.sh"

if [ ! -x "$ROOT_DIR/build.sh" ]; then
  printf '%s\n' "build.sh must be executable." >&2
  exit 1
fi

lint_plist() {
  if command -v plutil >/dev/null 2>&1; then
    plutil -lint "$ROOT_DIR/$1" >/dev/null
  elif command -v python3 >/dev/null 2>&1; then
    python3 - "$ROOT_DIR/$1" <<'PY'
import plistlib
import sys

with open(sys.argv[1], "rb") as plist_file:
    plistlib.load(plist_file)
PY
  else
    printf '%s\n' "No plist parser found; skipped $1."
  fi
}

lint_plist "GameOfThrows/Info.plist"
lint_plist "GameOfThrowsUITests/Info.plist"

for asset in \
  "GameOfThrows/bird.atlas/bird-01.png" \
  "GameOfThrows/bird.atlas/bird-02.png" \
  "GameOfThrows/Images.xcassets/sky.imageset/sky.png" \
  "GameOfThrows/Images.xcassets/land.imageset/land.png" \
  "GameOfThrows/Images.xcassets/PipeUp.imageset/pipeup.png" \
  "GameOfThrows/Images.xcassets/PipeDown.imageset/PipeDown.png"; do
  require_file "$asset"
done

for image_name in "bird-01" "bird-02" "sky" "land" "PipeUp" "PipeDown"; do
  if ! grep -Fq "\"$image_name\"" "$ROOT_DIR/GameOfThrows/GameScene.swift"; then
    printf '%s\n' "GameScene.swift must reference image asset $image_name." >&2
    exit 1
  fi
done

if ! grep -Fq "func testApplicationLaunches" "$ROOT_DIR/GameOfThrowsUITests/GameOfThrowsUITests.swift" ||
  ! grep -Fq "XCUIApplication().launch()" "$ROOT_DIR/GameOfThrowsUITests/GameOfThrowsUITests.swift" ||
  ! grep -Fq "XCTAssertTrue(XCUIApplication().exists)" "$ROOT_DIR/GameOfThrowsUITests/GameOfThrowsUITests.swift"; then
  printf '%s\n' "UI tests must keep a launch smoke test." >&2
  exit 1
fi

if ! grep -Fq "IOS_DESTINATION" "$ROOT_DIR/build.sh" ||
  ! grep -Fq "IOS_SIMULATOR_NAME" "$ROOT_DIR/build.sh" ||
  ! grep -Fq "xcodebuild" "$ROOT_DIR/build.sh"; then
  printf '%s\n' "build.sh must document configurable Xcode test execution." >&2
  exit 1
fi

if ! grep -Fq "guard let path" "$ROOT_DIR/GameOfThrows/GameViewController.swift" ||
  ! grep -Fq "as? SKView" "$ROOT_DIR/GameOfThrows/GameViewController.swift"; then
  printf '%s\n' "Scene loading and SKView access must stay optional-safe." >&2
  exit 1
fi

if ! grep -Fq "arc4random_uniform(height)" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "guard let bird = bird, let physicsBody = bird.physicsBody" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  grep -Eq 'arc4random\(\)[[:space:]]*%|physicsBody!.velocity' "$ROOT_DIR/GameOfThrows/GameScene.swift"; then
  printf '%s\n' "GameScene must avoid known pipe-randomness and physics force-unwrap hazards." >&2
  exit 1
fi

if ! grep -Fq "func scoreContactNode" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "if let scoringNode = scoreContactNode(contact)" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "scoringNode.physicsBody = nil" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "scoringNode.removeFromParent()" "$ROOT_DIR/GameOfThrows/GameScene.swift"; then
  printf '%s\n' "GameScene must remove score contact nodes after incrementing score." >&2
  exit 1
fi

if ! grep -Fq "GameOfThrowsUITests" "$ROOT_DIR/GameOfThrows.xcodeproj/project.pbxproj"; then
  printf '%s\n' "Xcode project must include the UI test target." >&2
  exit 1
fi

build_products=$(find "$ROOT_DIR" -path "$ROOT_DIR/.git" -prune -o \( -name DerivedData -o -name build -o -name xcuserdata -o -name ".DS_Store" -o -name "*.xcuserdatad" \) -print)
if [ -n "$build_products" ]; then
  printf '%s\n' "Generated Xcode/Finder output is present:" >&2
  printf '%s\n' "$build_products" >&2
  exit 1
fi

if ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "IOS_DESTINATION" "$ROOT_DIR/README.md" ||
  ! grep -Fq "IOS_SIMULATOR_NAME" "$ROOT_DIR/README.md" ||
  ! grep -Fq "score sensor" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document the baseline verification command and simulator override." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "launch smoke test" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "one score per pipe sensor" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must describe the current verification baseline." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$PLAN"; then
  printf '%s\n' "Plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$SCORE_PLAN"; then
  printf '%s\n' "Score-contact plan must be marked completed." >&2
  exit 1
fi

if command -v xcodebuild >/dev/null 2>&1; then
  (cd "$ROOT_DIR" && ./build.sh)
else
  printf '%s\n' "xcodebuild not found; static GameOfThrows baseline checks passed."
fi
