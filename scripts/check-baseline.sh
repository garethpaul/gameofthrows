#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PLAN="$ROOT_DIR/docs/plans/2026-06-08-gameofthrows-spritekit-baseline.md"
SCORE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-score-contact-idempotency.md"
IMPULSE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-single-tap-impulse-guard.md"
SCORE_RESET_PLAN="$ROOT_DIR/docs/plans/2026-06-09-score-label-restart-reset.md"
BIRD_SCORE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-score-contact-bird-pairing.md"
PIPE_SPAWN_PLAN="$ROOT_DIR/docs/plans/2026-06-09-pipe-spawn-readiness-guard.md"
MAKE_GATES_PLAN="$ROOT_DIR/docs/plans/2026-06-09-gameofthrows-make-gate-aliases.md"
GAMEPLAY_STATE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-gameplay-state-guard.md"
RESTART_RESOURCE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-restart-resource-guard.md"
CONTACT_RESOURCE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-contact-resource-guard.md"
CI_PLAN="$ROOT_DIR/docs/plans/2026-06-10-hosted-project-validation.md"
SCENE_LIFECYCLE_PLAN="$ROOT_DIR/docs/plans/2026-06-10-scene-action-lifecycle.md"
CI_POLICY_PLAN="$ROOT_DIR/docs/plans/2026-06-12-ci-policy-hardening.md"
SCHEME_TARGET_PLAN="$ROOT_DIR/docs/plans/2026-06-12-shared-scheme-target-integrity.md"
COLLISION_PAIR_PLAN="$ROOT_DIR/docs/plans/2026-06-13-explicit-collision-pairing.md"
PRESENTATION_PLAN="$ROOT_DIR/docs/plans/2026-06-13-scene-presentation-idempotency.md"
RESTART_ROTATION_PLAN="$ROOT_DIR/docs/plans/2026-06-13-restart-death-rotation-cancellation.md"
TEARDOWN_ROTATION_PLAN="$ROOT_DIR/docs/plans/2026-06-13-teardown-death-rotation-cancellation.md"
LOCATION_INDEPENDENT_MAKE_PLAN="$ROOT_DIR/docs/plans/2026-06-13-location-independent-make.md"
UPDATE_ROTATION_PLAN="$ROOT_DIR/docs/plans/2026-06-14-update-rotation-ownership.md"
UPDATE_ROTATION_CHECK="$ROOT_DIR/scripts/check-update-rotation-ownership.py"
APP_BUILD_CHECK="$ROOT_DIR/scripts/build-app.sh"
TEARDOWN_GAMEPLAY_PLAN="$ROOT_DIR/docs/plans/2026-06-16-teardown-gameplay-state.md"
TEARDOWN_RESTART_PLAN="$ROOT_DIR/docs/plans/2026-06-16-teardown-restart-revocation.md"
SWIFT_MODERNIZATION_PLAN="$ROOT_DIR/docs/plans/2026-06-17-swift-xcode-build-modernization.md"
HOSTED_UI_TEST_PLAN="$ROOT_DIR/docs/plans/2026-06-26-hosted-ui-launch-test.md"
CI_WORKFLOW="$ROOT_DIR/.github/workflows/check.yml"
PROJECT_FILE="$ROOT_DIR/GameOfThrows.xcodeproj/project.pbxproj"
SHARED_SCHEMES="$ROOT_DIR/GameOfThrows.xcodeproj/xcshareddata/xcschemes"
APP_SCHEME="$SHARED_SCHEMES/GameOfThrows.xcscheme"

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file missing: $path" >&2
    exit 1
  fi
}

for path in \
  ".github/CODEOWNERS" \
  ".github/workflows/check.yml" \
  ".gitignore" \
  "AGENTS.md" \
  "CHANGES.md" \
  "Makefile" \
  "README.md" \
  "SECURITY.md" \
  "VISION.md" \
  "build.sh" \
  "GameOfThrows/Info.plist" \
  "GameOfThrows.xcodeproj/project.pbxproj" \
  "GameOfThrows.xcodeproj/xcshareddata/xcschemes/GameOfThrows.xcscheme" \
  "GameOfThrows.xcodeproj/xcshareddata/xcschemes/GameOfThrowsUITests.xcscheme" \
  "GameOfThrows/GameScene.swift" \
  "GameOfThrows/GameViewController.swift" \
  "GameOfThrows/AppDelegate.swift" \
  "GameOfThrowsUITests/Info.plist" \
  "GameOfThrowsUITests/GameOfThrowsUITests.swift" \
  "scripts/check-update-rotation-ownership.py" \
  "scripts/build-app.sh" \
  "docs/plans/2026-06-14-update-rotation-ownership.md" \
  "docs/plans/2026-06-09-score-label-restart-reset.md" \
  "docs/plans/2026-06-09-contact-resource-guard.md" \
  "docs/plans/2026-06-09-score-contact-bird-pairing.md" \
  "docs/plans/2026-06-09-pipe-spawn-readiness-guard.md" \
  "docs/plans/2026-06-09-restart-resource-guard.md" \
  "docs/plans/2026-06-09-gameofthrows-make-gate-aliases.md" \
  "docs/plans/2026-06-09-gameplay-state-guard.md" \
  "docs/plans/2026-06-08-gameofthrows-spritekit-baseline.md" \
  "docs/plans/2026-06-09-single-tap-impulse-guard.md" \
  "docs/plans/2026-06-09-score-contact-idempotency.md" \
  "docs/plans/2026-06-10-hosted-project-validation.md" \
  "docs/plans/2026-06-10-scene-action-lifecycle.md" \
  "docs/plans/2026-06-12-ci-policy-hardening.md" \
  "docs/plans/2026-06-12-shared-scheme-target-integrity.md"; do
  require_file "$path"
done

require_file "docs/plans/2026-06-13-explicit-collision-pairing.md"
require_file "docs/plans/2026-06-13-scene-presentation-idempotency.md"
require_file "docs/plans/2026-06-13-restart-death-rotation-cancellation.md"
require_file "docs/plans/2026-06-13-teardown-death-rotation-cancellation.md"
require_file "docs/plans/2026-06-13-location-independent-make.md"
require_file "docs/plans/2026-06-16-teardown-gameplay-state.md"
require_file "docs/plans/2026-06-16-teardown-restart-revocation.md"
require_file "docs/plans/2026-06-17-swift-xcode-build-modernization.md"
require_file "docs/plans/2026-06-26-hosted-ui-launch-test.md"

python3 "$UPDATE_ROTATION_CHECK" \
  "$ROOT_DIR/GameOfThrows/GameScene.swift" \
  "$UPDATE_ROTATION_PLAN" \
  "$ROOT_DIR/scripts/check-baseline.sh"

if ! grep -Fq 'override ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))' "$ROOT_DIR/Makefile" ||
  ! grep -Fq '"$(ROOT)/scripts/check-baseline.sh"' "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile verification must protect the loaded Makefile root from overrides." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$LOCATION_INDEPENDENT_MAKE_PLAN" ||
  ! grep -Fq "from /tmp" "$LOCATION_INDEPENDENT_MAKE_PLAN" ||
  ! grep -Fq "absolute Makefile path" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Made static verification independent" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Location-independent Make plan and guidance must record completed external verification." >&2
  exit 1
fi

makefile="$ROOT_DIR/Makefile"
if ! grep -Eq '^\.PHONY: .*build.*check.*lint.*test|^\.PHONY: .*build.*lint.*test.*check' "$makefile" ||
  ! grep -Fq "lint test build: check" "$makefile"; then
  printf '%s\n' "Makefile must expose lint, test, build, and check gate targets." >&2
  exit 1
fi

python3 - \
  "$ROOT_DIR/GameOfThrows/AppDelegate.swift" \
  "$ROOT_DIR/GameOfThrows/GameViewController.swift" \
  "$ROOT_DIR/GameOfThrows/GameScene.swift" \
  "$ROOT_DIR/GameOfThrowsUITests/GameOfThrowsUITests.swift" \
  "$PROJECT_FILE" \
  "$CI_WORKFLOW" \
  "$APP_BUILD_CHECK" <<'PY'
import sys
from pathlib import Path

app_delegate, view_controller, scene, ui_tests, project, workflow, app_build = (
    Path(path).read_text(encoding="utf-8") for path in sys.argv[1:]
)

source_contracts = (
    (app_delegate, "@main"),
    (app_delegate, "didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?"),
    (view_controller, 'GameScene(fileNamed: "GameScene")'),
    (view_controller, "guard let skView = view as? SKView"),
    (scene, "override func didMove(to view: SKView)"),
    (scene, "override func willMove(from view: SKView)"),
    (scene, "override func update(_ currentTime: TimeInterval)"),
    (scene, "func didBegin(_ contact: SKPhysicsContact)"),
    (scene, "override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)"),
    (ui_tests, "app = XCUIApplication()"),
    (ui_tests, "XCTAssertTrue(app.exists)"),
)
if any(value not in source for source, value in source_contracts):
    raise SystemExit("Swift 5 source and SpriteKit lifecycle contracts are incomplete.")

legacy_spellings = (
    "@UIApplicationMain",
    "didMoveToView",
    "willMoveFromView",
    "didBeginContact",
    "removeActionForKey",
    "runAction",
    "CGVectorMake",
    "CGPointMake",
    "CGSizeMake",
    "repeatActionForever",
    "runBlock",
    "waitForDuration",
    "animateWithTextures",
    "rotateByAngle",
    "NSTimeInterval",
    "NSInteger",
)
all_swift = "\n".join((app_delegate, view_controller, scene, ui_tests))
if any(value in all_swift for value in legacy_spellings):
    raise SystemExit("Swift 2 source spellings must not return to the maintained targets.")

if project.count("SWIFT_VERSION = 5.0;") != 4:
    raise SystemExit("Application and UI-test Debug/Release configurations must use Swift 5.")
if project.count("IPHONEOS_DEPLOYMENT_TARGET = 12.0;") != 6:
    raise SystemExit("All project and target configurations must retain the iOS 12 deployment floor.")
if "IPHONEOS_DEPLOYMENT_TARGET = 9." in project:
    raise SystemExit("Unsupported iOS 9 deployment targets must not return.")

developer_dir = "DEVELOPER_DIR: /Applications/Xcode_16.4.app/Contents/Developer"
if workflow.count(developer_dir) != 1:
    raise SystemExit("Hosted validation must pin the installed Xcode 16.4 developer directory.")

build_contracts = (
    'xcodebuild \\\n',
    '-project "$ROOT_DIR/GameOfThrows.xcodeproj"',
    "-scheme GameOfThrows",
    "-configuration Debug",
    "-sdk iphonesimulator",
    "-destination 'generic/platform=iOS Simulator'",
    'CODE_SIGNING_ALLOWED=NO',
    'mktemp -d "${TMPDIR:-/tmp}/gameofthrows-derived-data.XXXXXX"',
    "  build\n",
)
if any(value not in app_build for value in build_contracts):
    raise SystemExit("The maintained Xcode gate must perform an isolated signing-disabled simulator build.")
PY

if ! grep -Fq "hosted Xcode 16.4 application build" "$ROOT_DIR/AGENTS.md" ||
  ! grep -Fq "generic iOS Simulator destination with code signing disabled" "$ROOT_DIR/README.md" ||
  ! grep -Fq "code-signing-disabled Swift 5 application build with pinned Xcode 16.4" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "Swift 5, iOS 12, and hosted Xcode 16.4 build boundary" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Migrated the app and UI launch test from Swift 2-era syntax to Swift 5" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Project guidance must document the maintained Swift 5 and hosted Xcode build boundary." >&2
  exit 1
fi

python3 - "$ROOT_DIR/GameOfThrows/GameScene.swift" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text()
rotation_helper = source[
    source.index("func cancelBirdDeathRotation"):
    source.index("func resetScenePresentation")
]
presentation_helper = source[
    source.index("func resetScenePresentation"):
    source.index("override func didMove(to view: SKView)")
]
presentation = source[
    source.index("override func didMove(to view: SKView)"):
    source.index("override func willMove(from view: SKView)")
]
teardown = source[
    source.index("override func willMove(from view: SKView)"):
    source.index("func spawnPipes")
]
cancel_rotation_helper = "cancelBirdDeathRotation()"
optional_rotation_cancel = 'bird?.removeAction(forKey: "deathRotation")'
if rotation_helper.count(optional_rotation_cancel) != 1:
    raise SystemExit("Bird death rotation helper must cancel the keyed action exactly once when present.")
if presentation_helper.count(cancel_rotation_helper) != 1:
    raise SystemExit("Scene presentation reset must cancel bird death rotation exactly once.")
if presentation_helper.index(cancel_rotation_helper) > presentation_helper.index("removeAllChildren()"):
    raise SystemExit("Scene presentation reset must cancel bird death rotation before child cleanup.")
if teardown.count(cancel_rotation_helper) != 1:
    raise SystemExit("View teardown must cancel bird death rotation exactly once.")
if teardown.index(cancel_rotation_helper) > teardown.index("physicsWorld.contactDelegate = nil"):
    raise SystemExit("View teardown must cancel bird death rotation before contact delegate cleanup.")
presentation_required = (
    'removeAction(forKey: "spawnPipes")',
    'removeAction(forKey: "flash")',
    "removeAllChildren()",
)
if any(presentation_helper.count(item) != 1 for item in presentation_required):
    raise SystemExit("Scene presentation reset must remove keyed actions and prior children.")
if presentation.count("resetScenePresentation()") != 1:
    raise SystemExit("didMove(to:) must reset prior scene presentation state exactly once.")
if presentation.index("resetScenePresentation()") > presentation.index("canRestart = false"):
    raise SystemExit("Scene presentation reset must run before gameplay setup begins.")

restart = source[
    source.index("func resetScene()"):
    source.index("override func touchesBegan")
]
collision = source[source.index("func didBegin(_ contact: SKPhysicsContact)"):]
cancel_rotation = 'bird.removeAction(forKey: "deathRotation")'
bird_reset = "bird.position = CGPoint("
if restart.count(cancel_rotation) != 1:
    raise SystemExit("Restart must cancel the prior keyed death rotation exactly once.")
if restart.index(cancel_rotation) > restart.index(bird_reset):
    raise SystemExit("Restart must cancel the death rotation before restoring bird state.")
death_rotation_required = (
    "let deathRotation = SKAction.rotate(byAngle:",
    "let stopBird = SKAction.run { bird.speed = 0 }",
    'bird.run(SKAction.sequence([deathRotation, stopBird]), withKey: "deathRotation")',
)
if any(collision.count(item) != 1 for item in death_rotation_required):
    raise SystemExit("Fatal collision rotation must remain one keyed stop sequence.")
if "completion:{bird.speed = 0 }" in collision:
    raise SystemExit("Fatal collision rotation must not retain an unkeyed late completion.")

required = (
    "func isBirdCollisionContact(_ contact: SKPhysicsContact) -> Bool",
    "let bodyAIsObstacle = bodyMatchesCategory(contact.bodyA, category: worldCategory) ||",
    "bodyMatchesCategory(contact.bodyA, category: pipeCategory)",
    "let bodyBIsObstacle = bodyMatchesCategory(contact.bodyB, category: worldCategory) ||",
    "bodyMatchesCategory(contact.bodyB, category: pipeCategory)",
    "return (bodyAIsBird && bodyBIsObstacle) || (bodyBIsBird && bodyAIsObstacle)",
    "if !isBirdCollisionContact(contact)",
)
if any(source.count(item) != 1 for item in required):
    raise SystemExit("GameScene must classify fatal contacts as explicit bird-world or bird-pipe pairs.")

score = source.index("if let scoringNode = scoreContactNode(contact)")
collision = source.index("if !isBirdCollisionContact(contact)")
game_over = source.index("moving.speed = 0", collision)
if not score < collision < game_over:
    raise SystemExit("GameScene must handle scoring before fatal collision classification and side effects.")

helper = source[source.index("func isBirdCollisionContact"):source.index("override func update")]
if "scoreCategory" in helper:
    raise SystemExit("Score sensors must not be classified as fatal collision bodies.")
PY

sh -n "$ROOT_DIR/build.sh"
sh -n "$APP_BUILD_CHECK"
sh -n "$ROOT_DIR/scripts/check-baseline.sh"

if [ ! -x "$ROOT_DIR/build.sh" ]; then
  printf '%s\n' "build.sh must be executable." >&2
  exit 1
fi

if [ ! -x "$APP_BUILD_CHECK" ]; then
  printf '%s\n' "scripts/build-app.sh must be executable." >&2
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
  ! grep -Fq "app = XCUIApplication()" "$ROOT_DIR/GameOfThrowsUITests/GameOfThrowsUITests.swift" ||
  ! grep -Fq "app.launch()" "$ROOT_DIR/GameOfThrowsUITests/GameOfThrowsUITests.swift" ||
  ! grep -Fq "XCTAssertTrue(app.exists)" "$ROOT_DIR/GameOfThrowsUITests/GameOfThrowsUITests.swift"; then
  printf '%s\n' "UI tests must keep a launch smoke test." >&2
  exit 1
fi

if ! grep -Fq "IOS_DESTINATION" "$ROOT_DIR/build.sh" ||
  ! grep -Fq "IOS_SIMULATOR_NAME" "$ROOT_DIR/build.sh" ||
  ! grep -Fq "xcodebuild" "$ROOT_DIR/build.sh"; then
  printf '%s\n' "build.sh must document configurable Xcode test execution." >&2
  exit 1
fi

if ! grep -Fq 'ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)' "$ROOT_DIR/build.sh" ||
  ! grep -Fq 'DEFAULT_PROJECT="$ROOT_DIR/GameOfThrows.xcodeproj"' "$ROOT_DIR/build.sh" ||
  ! grep -Fq 'PROJECT=${XCODE_PROJECT:-$DEFAULT_PROJECT}' "$ROOT_DIR/build.sh" ||
  ! grep -Fq 'derived_data=$(mktemp -d "${TMPDIR:-/tmp}/gameofthrows-test-derived-data.XXXXXX")' "$ROOT_DIR/build.sh" ||
  ! grep -Fq 'rm -rf -- "$derived_data"' "$ROOT_DIR/build.sh" ||
  ! grep -Fq -- '-derivedDataPath "$derived_data"' "$ROOT_DIR/build.sh"; then
  printf '%s\n' "build.sh must resolve the default project from the script directory and keep DerivedData in temp." >&2
  exit 1
fi

if ! grep -Fq 'let scene = GameScene(fileNamed: "GameScene")' "$ROOT_DIR/GameOfThrows/GameViewController.swift" ||
  ! grep -Fq "guard let skView = view as? SKView" "$ROOT_DIR/GameOfThrows/GameViewController.swift" ||
  ! grep -Fq "override var shouldAutorotate: Bool" "$ROOT_DIR/GameOfThrows/GameViewController.swift" ||
  ! grep -Fq "override var supportedInterfaceOrientations: UIInterfaceOrientationMask" "$ROOT_DIR/GameOfThrows/GameViewController.swift"; then
  printf '%s\n' "Scene loading, SKView access, and UIKit orientation overrides must stay modern and optional-safe." >&2
  exit 1
fi

if ! grep -Fq "arc4random_uniform(height)" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "guard let bird = bird, let physicsBody = bird.physicsBody" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  grep -Eq 'arc4random\(\)[[:space:]]*%|physicsBody!.velocity' "$ROOT_DIR/GameOfThrows/GameScene.swift"; then
  printf '%s\n' "GameScene must avoid known pipe-randomness and physics force-unwrap hazards." >&2
  exit 1
fi

if ! grep -Fq "func applyBirdImpulse" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "physicsBody.applyImpulse(CGVector(dx: 0, dy: 30))" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  grep -Fq "for touch" "$ROOT_DIR/GameOfThrows/GameScene.swift"; then
  printf '%s\n' "Touch handling must use the single guarded bird impulse helper." >&2
  exit 1
fi

if ! grep -Fq "func shouldSpawnPipes" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "if !shouldSpawnPipes()" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "moving.speed > 0" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "pipeTextureUp != nil" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "movePipesAndRemove != nil" "$ROOT_DIR/GameOfThrows/GameScene.swift"; then
  printf '%s\n' "Pipe spawning must guard paused movement and required scene resources." >&2
  exit 1
fi

if ! grep -Fq "func isGameplayRunning" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "return moving != nil && moving.speed > 0" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "if isGameplayRunning()" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "if !isGameplayRunning()" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  grep -Fq "if moving.speed > 0" "$ROOT_DIR/GameOfThrows/GameScene.swift"; then
  printf '%s\n' "Touch and contact handling must use the shared active-gameplay guard." >&2
  exit 1
fi

if ! grep -Fq "func scoreContactNode" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "func bodyMatchesCategory" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "let bodyAIsBird" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "let bodyBIsBird" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "if bodyAIsScore && bodyBIsBird" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "if bodyBIsScore && bodyAIsBird" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "if let scoringNode = scoreContactNode(contact)" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "scoringNode.physicsBody = nil" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "scoringNode.removeFromParent()" "$ROOT_DIR/GameOfThrows/GameScene.swift"; then
  printf '%s\n' "GameScene must score only bird-score contacts and remove score nodes after incrementing score." >&2
  exit 1
fi

if ! grep -Fq "scoreLabelNode.setScale(1.0)" "$ROOT_DIR/GameOfThrows/GameScene.swift"; then
  printf '%s\n' "GameScene restart must reset score label scale after score animations." >&2
  exit 1
fi

if ! grep -Fq "let skyColor = skyColor" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "let stopBird = SKAction.run { bird.speed = 0 }" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "self.backgroundColor = skyColor" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  grep -Fq "self.bird.speed = 0" "$ROOT_DIR/GameOfThrows/GameScene.swift"; then
  printf '%s\n' "GameScene contact handling must guard required scene resources and avoid delayed self.bird access." >&2
  exit 1
fi

if ! grep -Fq "[weak self] in self?.spawnPipes()" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq 'withKey: "spawnPipes"' "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "override func willMove(from view: SKView)" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq 'removeAction(forKey: "spawnPipes")' "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq 'removeAction(forKey: "flash")' "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "physicsWorld.contactDelegate = nil" "$ROOT_DIR/GameOfThrows/GameScene.swift"; then
  printf '%s\n' "GameScene must release repeating actions and contact callbacks when leaving its view." >&2
  exit 1
fi

python3 - "$ROOT_DIR/GameOfThrows/GameScene.swift" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text()
teardown = source.split("override func willMove(from view: SKView)", 1)[-1].split(
    "func spawnPipes", 1
)[0]
contracts = (
    "canRestart = false",
    "moving?.speed = 0",
    "cancelBirdDeathRotation()",
    'removeAction(forKey: "spawnPipes")',
    'removeAction(forKey: "flash")',
    "physicsWorld.contactDelegate = nil",
)
if any(teardown.count(contract) != 1 for contract in contracts):
    raise SystemExit(
        "GameScene teardown must stop optional gameplay state once before releasing callback ownership."
    )
positions = [teardown.index(contract) for contract in contracts]
if positions != sorted(positions):
    raise SystemExit(
        "GameScene teardown must revoke restart and stop gameplay before releasing callback ownership."
    )
if "moving.speed = 0" in teardown:
    raise SystemExit("GameScene teardown must remain safe before moving is initialized.")
PY

if ! grep -Fq "guard let bird = bird" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "let pipes = pipes" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "let moving = moving" "$ROOT_DIR/GameOfThrows/GameScene.swift" ||
  ! grep -Fq "let scoreLabelNode = scoreLabelNode" "$ROOT_DIR/GameOfThrows/GameScene.swift"; then
  printf '%s\n' "GameScene restart must guard required scene resources before resetting." >&2
  exit 1
fi

if ! grep -Fq "GameOfThrowsUITests" "$ROOT_DIR/GameOfThrows.xcodeproj/project.pbxproj"; then
  printf '%s\n' "Xcode project must include the UI test target." >&2
  exit 1
fi

native_target_ids=$(sed -n '/Begin PBXNativeTarget section/,/End PBXNativeTarget section/ {
  s/^[[:space:]]*\([A-F0-9]\{24\}\) \/\*.*/\1/p
}' "$PROJECT_FILE")

for scheme in "$SHARED_SCHEMES"/*.xcscheme; do
  blueprint_ids=$(sed -n 's/.*BlueprintIdentifier = "\([^"]*\)".*/\1/p' "$scheme")
  for blueprint_id in $blueprint_ids; do
    if ! printf '%s\n' "$native_target_ids" | grep -Fxq "$blueprint_id"; then
      printf '%s\n' "Shared scheme references missing project target $blueprint_id: $scheme" >&2
      exit 1
    fi
  done
done

if grep -Fq "GameOfThrowsTests.xctest" "$APP_SCHEME" ||
  ! grep -Fq "GameOfThrowsUITests.xctest" "$APP_SCHEME"; then
  printf '%s\n' "App scheme must retain the UI test target without the removed unit test target." >&2
  exit 1
fi

build_products=$(find "$ROOT_DIR" -path "$ROOT_DIR/.git" -prune -o \( -name DerivedData -o -name build -o -name xcuserdata -o -name ".DS_Store" -o -name "*.xcuserdatad" \) -print)
if [ -n "$build_products" ]; then
  printf '%s\n' "Generated Xcode/Finder output is present:" >&2
  printf '%s\n' "$build_products" >&2
  exit 1
fi

if ! grep -Fq "make lint" "$ROOT_DIR/README.md" ||
  ! grep -Fq "make test" "$ROOT_DIR/README.md" ||
  ! grep -Fq "make build" "$ROOT_DIR/README.md" ||
  ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "IOS_DESTINATION" "$ROOT_DIR/README.md" ||
  ! grep -Fq "IOS_SIMULATOR_NAME" "$ROOT_DIR/README.md" ||
  ! grep -Fq "one bird impulse per touch event" "$ROOT_DIR/README.md" ||
  ! grep -Fq "score sensor" "$ROOT_DIR/README.md" ||
  ! grep -Fq "bird-score contact" "$ROOT_DIR/README.md" ||
  ! grep -Fq "pipe spawning" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Restart checks required scene resources" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Contact handling guards required scene resources" "$ROOT_DIR/README.md" ||
  ! grep -Fq "weak scene capture" "$ROOT_DIR/README.md" ||
  ! grep -Fq "active-gameplay guard" "$ROOT_DIR/README.md" ||
  ! grep -Fq "score label scale" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document the baseline verification command and simulator override." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "make lint" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "make test" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "make build" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "launch smoke test" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "one bird impulse per touch event" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "one score per pipe sensor" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "bird-score contact" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "pipe spawning" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Restart checks required scene resources" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Contact handling guards required scene resources" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "tears down repeating actions" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "active-gameplay guard" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "score label scale" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must describe the current verification baseline." >&2
  exit 1
fi

if ! grep -Fq "Gameplay contact paths should guard required SpriteKit scene resources" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "Repeating SpriteKit actions should not retain scenes" "$ROOT_DIR/SECURITY.md"; then
  printf '%s\n' "SECURITY must document the contact resource boundary." >&2
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

if ! grep -Fq "status: completed" "$IMPULSE_PLAN"; then
  printf '%s\n' "Single-tap impulse plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$SCORE_RESET_PLAN"; then
  printf '%s\n' "Score label restart reset plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$BIRD_SCORE_PLAN"; then
  printf '%s\n' "Bird-score contact plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$PIPE_SPAWN_PLAN"; then
  printf '%s\n' "Pipe spawn readiness plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$MAKE_GATES_PLAN"; then
  printf '%s\n' "Make gate alias plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$GAMEPLAY_STATE_PLAN"; then
  printf '%s\n' "Gameplay state guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$RESTART_RESOURCE_PLAN"; then
  printf '%s\n' "Restart resource guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$CONTACT_RESOURCE_PLAN"; then
  printf '%s\n' "Contact resource guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$RESTART_RESOURCE_PLAN"; then
  printf '%s\n' "Restart resource guard plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "make check" "$CONTACT_RESOURCE_PLAN"; then
  printf '%s\n' "Contact resource guard plan must record make check verification." >&2
  exit 1
fi

if command -v xcodebuild >/dev/null 2>&1; then
  "$APP_BUILD_CHECK"
else
  printf '%s\n' "xcodebuild not found; Swift/Xcode application build skipped after static GameOfThrows baseline checks passed."
fi

workflow_files=$(find "$ROOT_DIR/.github/workflows" -type f -print)
if [ "$workflow_files" != "$CI_WORKFLOW" ]; then
  printf '%s\n' "check.yml must remain the only hosted workflow." >&2
  exit 1
fi

expected_workflow=$(mktemp "${TMPDIR:-/tmp}/gameofthrows-check.XXXXXX")
trap 'rm -f "$expected_workflow"' EXIT HUP INT TERM
cat >"$expected_workflow" <<'EOF'
name: Check

on:
  pull_request:
  push:
  workflow_dispatch:

permissions:
  contents: read

concurrency:
  group: check-${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  check:
    runs-on: macos-15
    timeout-minutes: 10
    env:
      DEVELOPER_DIR: /Applications/Xcode_16.4.app/Contents/Developer
    steps:
      - name: Check out repository
        uses: actions/checkout@9f698171ed81b15d1823a05fc7211befd50c8ae0 # v6.0.3
        with:
          persist-credentials: false
      - name: Run project baseline
        run: make check
      - name: Run UI launch test
        env:
          IOS_DESTINATION: platform=iOS Simulator,name=iPhone 16 Pro,OS=18.5
        run: ./build.sh
EOF

if ! cmp -s "$expected_workflow" "$CI_WORKFLOW"; then
  printf '%s\n' "GitHub Actions must match the canonical bounded, credential-free macOS check." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$HOSTED_UI_TEST_PLAN" ||
  ! grep -Fq "iPhone 16 Pro" "$HOSTED_UI_TEST_PLAN" ||
  ! grep -Fq "iOS 18.5" "$HOSTED_UI_TEST_PLAN" ||
  ! grep -Fq "28271229926" "$HOSTED_UI_TEST_PLAN" ||
  ! grep -Fq "28271230831" "$HOSTED_UI_TEST_PLAN" ||
  ! grep -Fq "99b51a81dc25b0a294760d7c64ae6a9cccb44735" "$HOSTED_UI_TEST_PLAN" ||
  ! grep -Fq "5e610bbfccdf27a47e50f9a1f5abbb1c2851536a" "$HOSTED_UI_TEST_PLAN"; then
  printf '%s\n' "Hosted UI launch-test plan must record completed pinned simulator evidence." >&2
  exit 1
fi

if [ "$(cat "$ROOT_DIR/.github/CODEOWNERS")" != "* @garethpaul" ]; then
  printf '%s\n' "CODEOWNERS must assign repository-wide ownership." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$CI_PLAN" ||
  ! grep -Fq "make check" "$CI_PLAN"; then
  printf '%s\n' "Hosted project validation plan must be completed and record verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$SCENE_LIFECYCLE_PLAN" ||
  ! grep -Fq "Mutations restoring strong spawn capture or removing teardown must fail" "$SCENE_LIFECYCLE_PLAN"; then
  printf '%s\n' "Scene action lifecycle plan must record completed mutation verification." >&2
  exit 1
fi

python3 - "$COLLISION_PAIR_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "collision guard mutation failed",
    "score-as-collision mutation failed",
    "classification order mutation failed",
    "hosted pull-request check",
)
if (
    statuses != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "Explicit collision pairing plan must remain completed with actual verification recorded."
    )
PY

python3 - "$PRESENTATION_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "presentation reset mutation failed",
    "child cleanup mutation failed",
    "setup ordering mutation failed",
    "hosted pull-request check",
)
if (
    statuses != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "Scene presentation idempotency plan must remain completed with actual verification recorded."
    )
PY

python3 - "$RESTART_ROTATION_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "action key mutation failed",
    "restart cancellation mutation failed",
    "cancellation ordering mutation failed",
    "hosted pull-request check",
)
if (
    statuses != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "Restart death rotation cancellation plan must remain completed with actual verification recorded."
    )
PY

python3 - "$TEARDOWN_ROTATION_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "five hostile mutations were rejected",
    "all four Make gates passed",
    "xcodebuild was unavailable",
    "No SpriteKit runtime",
)
if (
    statuses != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "Teardown death rotation cancellation plan must remain completed with actual verification recorded."
    )
PY

if ! grep -Fq "only explicit bird-world or bird-pipe contacts end a run" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Only explicit bird-world or bird-pipe contacts should trigger game-over" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "Only explicit bird-world or bird-pipe contacts stop gameplay" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Required explicit bird-world or bird-pipe pairing" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Project guidance must document explicit fatal collision pairing." >&2
  exit 1
fi

if ! grep -Fq "Presentation reset and view teardown cancel the bird's keyed death rotation before releasing child or delegate ownership" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Presentation reset and view teardown should cancel the bird's keyed death rotation before child or contact-delegate cleanup" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "Presentation reset and view teardown cancel the bird's keyed death rotation before releasing child or delegate ownership" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Cancelled the bird's keyed death rotation before scene presentation reset and view teardown cleanup" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "Cancel keyed bird collision actions before removing scene children or clearing the physics contact delegate" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Project guidance must document cancellation before scene ownership cleanup." >&2
  exit 1
fi

if ! grep -Fq "View teardown revokes restart eligibility and stops the moving graph first" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Teardown should revoke restart eligibility and stop the moving graph before" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "View teardown revokes restart eligibility and stops the moving graph before" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Revoked restart eligibility before scene teardown stops movement" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "Stopped the moving gameplay graph before scene teardown releases keyed" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "Revoke restart eligibility and stop the optional moving gameplay graph before" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Project guidance must document restart revocation and gameplay shutdown before teardown ownership cleanup." >&2
  exit 1
fi

if ! grep -Fq "Scene presentation clears prior keyed actions and child nodes before rebuilding gameplay" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Scene presentation should clear prior keyed actions and child nodes before rebuilding gameplay" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "Scene presentation clears prior keyed actions and child nodes before rebuilding gameplay" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Made repeated scene presentation clear prior keyed actions and child nodes" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "Clear prior keyed actions and child nodes before rebuilding a presented scene" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Project guidance must document idempotent scene presentation." >&2
  exit 1
fi

if ! grep -Fq "Restart cancels the keyed death rotation before restoring bird state" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Restart should cancel pending keyed collision actions before restoring bird state" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "Restart cancels pending keyed collision work before restoring bird state" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Cancelled the keyed death rotation before restart restores bird state" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "Cancel pending keyed collision actions before restoring restart state" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Project guidance must document restart cancellation of stale collision work." >&2
  exit 1
fi

python3 - "$SCHEME_TARGET_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
statuses = re.findall(r"^status: .+$", plan, flags=re.MULTILINE)
parts = plan.split("## Verification Completed\n", 1)
verification = parts[1] if len(parts) == 2 else ""
required = (
    "`make lint`, `make test`, `make build`, `make check`",
    "push run `27392844491`",
    "pull-request run `27392848940`",
    "push run `27392863018`",
    "CodeQL run `27402320931`",
    "Mutations restoring the orphaned target",
    "No simulator Test action or runtime gameplay coverage is claimed.",
)

if (
    statuses != ["status: completed"]
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "Shared scheme target-integrity plan must remain completed with actual verification recorded."
    )
PY

if ! grep -Fq "status: completed" "$CI_POLICY_PLAN" ||
  ! grep -Fq "persist-credentials: false" "$CI_POLICY_PLAN" ||
  ! grep -Fq "hostile workflow mutations" "$CI_POLICY_PLAN"; then
  printf '%s\n' "CI policy hardening plan must record completed mutation verification." >&2
  exit 1
fi

python3 - "$TEARDOWN_GAMEPLAY_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
normalized_verification = " ".join(verification.split())
required = (
    "All four Make gates passed",
    "External-directory `make check` passed",
    "Eight isolated mutations were rejected",
    "no actionable findings or testing gaps",
    "`xcodebuild` was unavailable",
    "No SpriteKit runtime",
    "PR #14 exact-head snapshot",
    "canonical macOS `check` in progress",
    "No polling wait was started",
)
if (
    statuses != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in normalized_verification for item in required)
    or re.search(r"\b(?:todo|tbd|not run)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "Teardown gameplay state plan must record completed status, actual verification, and the runtime boundary."
    )
PY

python3 - "$TEARDOWN_RESTART_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
normalized_verification = " ".join(verification.split())
required = (
    "All four Make gates passed",
    "External-directory `make check` passed",
    "Six isolated mutations were rejected",
    "no actionable findings or testing gaps",
    "`xcodebuild` was unavailable",
    "No SpriteKit runtime",
    "PR #15 exact-head checks",
    "push run 27646582344",
    "pull-request run 27646590073",
    "zero open alerts",
)
if (
    statuses != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in normalized_verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "Teardown restart revocation plan must record completed status, actual verification, and the runtime boundary."
    )
PY

python3 - "$SWIFT_MODERNIZATION_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
normalized_verification = " ".join(verification.split())
required = (
    "All four Make gates passed",
    "external-directory `make check` passed",
    "Ten isolated mutations were rejected",
    "`xcodebuild` was unavailable on Linux",
    "no local UIKit, SpriteKit, simulator, rendering, touch, or gameplay-runtime result is claimed",
    "`a92e9258c804c4e3a83da8d30c296f31fe8decdb`",
    "push run `27718662618`",
    "pull-request run `27718664377`",
    "PR #16 remained open and mergeable",
)
if (
    statuses != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in normalized_verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run|not yet)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "Swift/Xcode modernization plan must record completed status, actual hosted evidence, and the runtime boundary."
    )
PY
