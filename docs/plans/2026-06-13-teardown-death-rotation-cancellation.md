---
title: Teardown Death Rotation Cancellation
type: reliability
status: completed
date: 2026-06-13
---

# Teardown Death Rotation Cancellation

## Summary

Cancel the bird's keyed death-rotation sequence before scene presentation reset
or view teardown releases SpriteKit ownership.

## Requirements

- R1. Add one helper that removes the bird's `deathRotation` action when a bird
  exists.
- R2. Invoke the helper before `removeAllChildren()` during presentation reset.
- R3. Invoke the helper before clearing the contact delegate during view
  teardown.
- R4. Keep restart cancellation, spawn/flash cleanup, scoring, collision, and
  scene setup behavior unchanged.
- R5. Add ordering, uniqueness, documentation, completion, and mutation
  contracts.
- R6. Do not claim simulator, device, or runtime SpriteKit verification.

## Verification Plan

- Run all four Make gates plus shell, plist/project/workspace, and diff checks.
- Reject helper removal, presentation-order drift, teardown-order drift, stale
  plan, and missing evidence mutations.
- Take one bounded exact-head push/PR/code-scanning snapshot after push.

## Non-Goals

- Changing death animation timing, restart eligibility, physics, or scoring.
- Replacing legacy SpriteKit APIs or project settings.

## Verification Completed

- `make lint`, `make test`, `make build`, and `make check` completed; all four Make gates passed against the same working tree.
- The five hostile mutations were rejected: helper removal, presentation cleanup
  reordering, teardown cleanup reordering, stale plan status, and missing
  verification evidence.
- xcodebuild was unavailable on the Linux validation host.
- No SpriteKit runtime, simulator, or device verification is claimed.
