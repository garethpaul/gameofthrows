---
title: Teardown Gameplay State
type: reliability
status: planned
date: 2026-06-16
execution: code
---

# Teardown Gameplay State

## Context

`willMoveFromView` removes the scene-owned spawn and flash actions, cancels the
bird's keyed death rotation, and clears the physics contact delegate. It does
not stop the `moving` node. The shared `isGameplayRunning()` predicate therefore
continues to return true while the scene is leaving its view, allowing a late
frame, touch, or action callback to pass the active-gameplay guard and mutate a
detached scene.

## Priority

This is the highest-value remaining isolated lifecycle boundary because every
guarded gameplay entry point relies on `moving.speed > 0` as the authority for
whether the current round is active. Teardown should revoke that authority
before cancelling callbacks and releasing contact ownership.

## Requirements

- R1. Stop the current moving gameplay graph during `willMoveFromView` when it
  exists.
- R2. Stop gameplay before cancelling keyed scene actions or clearing the
  physics contact delegate.
- R3. Preserve presentation rebuilding, restart behavior, collision handling,
  scoring, pipe timing, and death-animation timing.
- R4. Keep teardown safe when `moving` has not been initialized.
- R5. Add source-order, documentation, completed-plan, and mutation-sensitive
  baseline contracts.
- R6. Record the Linux static-validation boundary without claiming SpriteKit,
  simulator, or device runtime execution.

## Implementation Units

### 1. Revoke Gameplay State During Teardown

Files: `GameOfThrows/GameScene.swift`

- Set the optional `moving` node's speed to zero at the start of
  `willMoveFromView`.
- Keep death-rotation cancellation, spawn/flash removal, and contact-delegate
  cleanup in their existing order after gameplay is stopped.

### 2. Protect the Lifecycle Contract

Files: `scripts/check-baseline.sh`, `README.md`, `SECURITY.md`, `VISION.md`,
`CHANGES.md`, `AGENTS.md`

- Require optional-safe movement shutdown and its ordering before teardown
  action/delegate cleanup.
- Document that teardown changes the shared active-gameplay predicate before
  releasing callback ownership.

### 3. Record Verification Evidence

Files: `docs/plans/2026-06-16-teardown-gameplay-state.md`

- Record actual focused, full-gate, external-directory, mutation, audit, and
  hosted results after execution.

## Verification

- Run `sh -n scripts/check-baseline.sh` and `sh -n build.sh`.
- Run `make check`, `make lint`, `make test`, and `make build` with bounded
  commands, plus `make check` through the absolute Makefile path from an
  external directory.
- Reject isolated mutations that remove the movement stop, make it unsafe for
  incomplete setup, move it after keyed-action or delegate cleanup, remove
  guidance, or falsify completed-plan evidence.
- Audit the exact diff, generated artifacts, credential-like additions, file
  modes, conflict markers, and branch/upstream state.
- Take one bounded exact-head pull-request, check, and security snapshot after
  push; do not start an unbounded wait.

## Risks And Boundaries

- Linux cannot execute SpriteKit, Xcode, simulator, or device lifecycle timing;
  the maintained local proof is source-order and project-structure validation.
- Stopping `moving` during teardown intentionally freezes child movement and
  makes the existing gameplay predicate false. A later presentation rebuilds a
  fresh moving graph, so no resume behavior is changed.
- This plan does not modernize Swift 2 syntax or change legacy project settings.

## Assumptions

- `willMoveFromView` is the repository's authoritative scene teardown hook.
- The existing `isGameplayRunning()` predicate remains the shared gate for
  touch, contact, pipe-spawn, and frame-update work.
