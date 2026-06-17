#!/usr/bin/env python3
import sys
from pathlib import Path


source = Path(sys.argv[1]).read_text(encoding="utf-8")
plan = Path(sys.argv[2]).read_text(encoding="utf-8")
baseline = Path(sys.argv[3]).read_text(encoding="utf-8")

start = source.find("override func update(_ currentTime: TimeInterval)")
end = source.find("\n    func didBegin(_ contact: SKPhysicsContact)", start)
if start == -1 or end == -1:
    raise SystemExit("GameScene update boundary is missing.")

update = source[start:end]
gameplay_guard = """if !isGameplayRunning() {
            return
        }"""
guard_index = update.find(gameplay_guard)
physics_index = update.find("guard let bird = bird, let physicsBody = bird.physicsBody")
velocity_index = update.find("let verticalVelocity = physicsBody.velocity.dy")
rotation_index = update.find("bird.zRotation = clamp(")
if -1 in (guard_index, physics_index, velocity_index, rotation_index):
    raise SystemExit("GameScene update rotation ownership contract is incomplete.")
if not guard_index < physics_index < velocity_index < rotation_index:
    raise SystemExit("Gameplay must stop update before physics access and rotation assignment.")

for evidence in (
    "status: completed",
    "six isolated hostile mutations were rejected",
    "absolute Makefile path from `/tmp`",
    "Xcode, SpriteKit, simulator, device, and gameplay execution were unavailable",
):
    if evidence not in plan:
        raise SystemExit("Rotation ownership plan evidence missing: " + evidence)

for integration in (
    'UPDATE_ROTATION_CHECK="$ROOT_DIR/scripts/check-update-rotation-ownership.py"',
    'python3 "$UPDATE_ROTATION_CHECK"',
    '"$ROOT_DIR/GameOfThrows/GameScene.swift"',
    '"$UPDATE_ROTATION_PLAN"',
):
    if integration not in baseline:
        raise SystemExit("Rotation ownership checker integration missing: " + integration)

print("GameScene update rotation ownership checks passed.")
