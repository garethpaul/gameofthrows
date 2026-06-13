---
title: Restart Death Rotation Cancellation
date: 2026-06-13
status: completed
execution: code
---

## Context

A fatal contact starts a one-second bird rotation whose completion sets
`bird.speed` to zero. The flash sequence enables restart after roughly 0.4
seconds, so a player can restart while the old rotation is still active. The
restart restores bird state, but the prior completion can then fire against the
restarted bird and stop its animation.

## Priority

This is the highest-value remaining isolated restart boundary because stale
collision work can mutate a new gameplay round after reset. The fix can make
that ownership explicit without changing collision classification, timing,
physics, scoring, or the restart gesture.

## Prioritized Backlog

1. Give the fatal bird rotation one stable action key.
2. Cancel that action before restart mutates bird position, velocity, speed, or
   rotation.
3. Preserve the current one-second rotation and final stopped animation when a
   restart does not occur.
4. Add source-order and hostile-mutation contracts plus repository guidance.
5. Keep runtime rapid-restart coverage and Swift modernization as separate work
   requiring a compatible legacy simulator toolchain.

## Implementation

- Express the existing rotation and final `bird.speed = 0` transition as a
  keyed action sequence.
- Remove the keyed action at the start of the guarded restart path before any
  bird state is restored.
- Extend the static baseline to require the action key, cancellation, ordering,
  documentation, and completed verification evidence.
- Update README, SECURITY, VISION, CHANGES, and AGENTS guidance with the stale
  collision-action boundary.

## Verification Plan

- Run shell syntax, all four Make gates, plist/project/workspace parsing,
  `git diff --check`, and intended-file artifact and secret checks.
- Remove the action key, remove restart cancellation, and move cancellation
  after bird reset state; each hostile mutation must fail.
- Take one bounded exact-head pull-request and code-scanning snapshot after
  push; do not poll.

## Work Completed

- Converted the existing fatal rotation and final bird stop into one keyed
  `deathRotation` action sequence.
- Cancelled the keyed sequence before restart restores bird position, velocity,
  collision state, speed, rotation, score, or movement.
- Added source-shape, ordering, documentation, and completed-plan contracts.

## Verification Completed

- The action key mutation failed after replacing the keyed sequence with an
  unkeyed run action.
- The restart cancellation mutation failed after removing the keyed action
  removal from `resetScene`.
- The cancellation ordering mutation failed after moving action removal below
  bird position restoration.
- Shell syntax, all four Make gates, plist/project/workspace parsing,
  `git diff --check`, and intended-file artifact and secret scans passed.
- The hosted pull-request check is a post-push evidence step; its bounded
  exact-head result is recorded after the implementation commit is pushed.
- `xcodebuild`, SpriteKit runtime execution, and rapid restart interaction are
  unavailable on this Linux host and are not claimed.
