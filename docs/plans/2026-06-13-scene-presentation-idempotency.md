---
title: Idempotent Scene Presentation
date: 2026-06-13
status: planned
execution: code
---

## Context

`didMoveToView` builds the complete gameplay node graph every time SpriteKit
presents the scene. `willMoveFromView` stops scene actions and contact callbacks,
but it leaves the previous bird, ground, moving graph, pipes, and score label in
place. Presenting the same `GameScene` instance again therefore appends duplicate
gameplay nodes and leaves stale child actions running beside the new graph.

## Priority

This is the highest-value remaining isolated lifecycle guard because scene
presentation owns every visible and interactive gameplay node. Making that
boundary idempotent prevents duplicated physics bodies and rendering work while
preserving the current first-presentation behavior.

## Prioritized Backlog

1. Clear prior scene-owned keyed actions before rebuilding the scene.
2. Remove the prior child graph before adding the new moving graph and gameplay
   nodes.
3. Preserve first presentation, teardown, collision, scoring, and restart
   behavior.
4. Add source-order and hostile-mutation contracts plus repository guidance.
5. Keep runtime re-presentation coverage and Swift modernization as separate
   work requiring a compatible legacy simulator toolchain.

## Implementation

- Add a small scene-presentation reset helper that removes the `spawnPipes` and
  `flash` actions and clears existing children.
- Call the helper at the start of `didMoveToView`, before any gameplay node is
  created.
- Extend the static baseline to require the cleanup operations and their order
  relative to scene reconstruction.
- Update README, SECURITY, VISION, CHANGES, and AGENTS guidance with the
  re-presentation boundary.

## Verification Plan

- Run shell syntax, all four Make gates, plist/project/workspace parsing,
  `git diff --check`, and intended-file secret checks.
- Remove the presentation reset call, omit child removal, and move cleanup after
  the first child insertion; each hostile mutation must fail.
- Take one bounded exact-head pull-request and CodeQL snapshot after push; do
  not poll.

## Work Completed

- Pending implementation.

## Verification Completed

- Pending implementation and verification.
