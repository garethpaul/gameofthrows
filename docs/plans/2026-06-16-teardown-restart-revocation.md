---
title: Teardown Restart Revocation
type: reliability
status: planned
date: 2026-06-16
execution: code
---

# Teardown Restart Revocation

## Context

`willMoveFromView` now stops the moving graph before releasing scene-owned
actions and contact handling. It does not clear `canRestart`. After the death
flash enables restart, a late touch during teardown can therefore enter
`resetScene()` and set `moving.speed = 1`, reactivating gameplay on a detached
scene.

## Requirements

- R1. Revoke restart eligibility at the start of `willMoveFromView`.
- R2. Revoke restart eligibility before stopping movement or releasing keyed
  actions and contact ownership.
- R3. Preserve normal death-to-restart behavior while the scene remains
  presented.
- R4. Add source-order, documentation, completed-plan, and mutation-sensitive
  baseline contracts.
- R5. Record the Linux static-validation boundary without claiming SpriteKit,
  simulator, or device runtime execution.

## Non-Goals

- Do not change collision classification, score handling, pipe timing,
  presentation rebuilding, or the normal restart sequence.
- Do not modernize the Swift 2 or iOS 9-era project.

## Implementation

1. Set `canRestart = false` before stopping the optional moving graph in
   `willMoveFromView`.
2. Extend the baseline checker to enforce latch revocation and ordering before
   movement, action, and delegate cleanup.
3. Update project guidance and change history with the teardown restart
   boundary.
4. Record actual focused, full-gate, external-directory, mutation, review, and
   hosted verification evidence.

## Verification

- Run `sh -n scripts/check-baseline.sh` and `sh -n build.sh`.
- Run `make check`, `make lint`, `make test`, and `make build` with explicit
  timeouts, plus the absolute-Makefile check from an external directory.
- Reject isolated mutations that remove latch revocation, set the wrong value,
  move it after movement or ownership cleanup, remove guidance, or reopen plan
  evidence.
- Audit the exact diff, generated artifacts, credential-like additions, file
  modes, conflict markers, and branch/upstream state.

## Risks And Boundaries

- Linux cannot execute SpriteKit, Xcode, simulator, or device lifecycle timing;
  the maintained local proof is source-order and project-structure validation.
- The normal in-view restart path remains controlled by the death flash and is
  intentionally unchanged.
