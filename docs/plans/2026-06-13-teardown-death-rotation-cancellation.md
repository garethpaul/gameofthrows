---
title: Teardown Death Rotation Cancellation
type: reliability
status: planned
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
