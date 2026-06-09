# Gameplay State Guard

status: completed

## Context

`touchesBegan`, `didBeginContact`, and `spawnPipes()` all need to know whether
gameplay is currently moving. Reading `moving.speed` directly from each path
keeps an implicitly unwrapped scene node in several runtime callbacks.

## Completed Scope

- Added `isGameplayRunning()` as the shared movement-state predicate.
- Routed touch input, physics contacts, and pipe spawning through the shared
  guard before applying gameplay actions.
- Extended the static baseline and docs so active gameplay checks remain
  centralized.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
