---
title: Explicit Bird Collision Pairing
date: 2026-06-13
status: completed
execution: code
---

## Context

`didBeginContact` awards points only for an explicit bird-score pairing, but it
treats every other contact as a fatal collision. That is safe for the current
category matrix, yet a future sensor or category change could make unrelated
physics bodies stop gameplay without ever touching the bird.

## Priority

This is the highest-value remaining isolated gameplay correctness guard because
contact classification directly controls score and game-over state. It closes
an unintended state transition without changing the current bird, pipe, ground,
or score behavior.

## Prioritized Backlog

1. Classify fatal contacts only when the bird is paired with world or pipe.
2. Preserve explicit bird-score handling before fatal collision handling.
3. Ignore unrelated contacts without changing movement, collision masks,
   animations, score, or restart state.
4. Add static ordering and hostile-mutation contracts plus repository guidance.
5. Keep runtime gameplay verification and Swift modernization as separate work.

## Implementation

- Add a small category-pair helper to `GameScene` using the existing
  `bodyMatchesCategory` primitive.
- Return early from `didBeginContact` when a contact is neither bird-score nor
  bird-world/bird-pipe.
- Extend the static baseline to require explicit pairing and classification
  order.
- Update README, SECURITY, VISION, and CHANGES with the contact boundary.

## Verification Plan

- Run shell syntax, all four Make gates, plist/project/workspace parsing,
  `git diff --check`, and intended-file secret checks.
- Remove the collision-pair guard, allow score bodies as fatal collisions, and
  move fatal classification before score handling; each hostile mutation must
  fail.
- Take one bounded exact-head pull-request and CodeQL snapshot after push; do
  not poll.

## Work Completed

- Added explicit symmetric bird-to-world-or-pipe contact classification using
  the existing category bitmask helper.
- Preserved bird-score handling first, then returned early for contacts that
  are neither scoring nor fatal collisions.
- Kept existing collision masks, movement stop, rotation, flash, and restart
  behavior unchanged for current bird-world and bird-pipe contacts.
- Added source-order, category-scope, documentation, and completed-plan
  regression contracts.

## Verification Completed

- A pristine copied tree passed `make check` with completed-plan evidence
  supplied in the copy.
- The collision guard mutation failed after removing the explicit classifier
  call.
- The score-as-collision mutation failed after adding `scoreCategory` to the
  fatal obstacle helper.
- The classification order mutation failed after moving fatal classification
  before score handling.
- The hosted pull-request check is a post-push evidence step; its bounded
  exact-head result is recorded after the implementation commit is pushed.
