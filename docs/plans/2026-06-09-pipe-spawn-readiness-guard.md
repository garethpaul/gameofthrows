# Pipe Spawn Readiness Guard

status: completed

## Context

The scene starts a repeating action that calls `spawnPipes()`. When gameplay is
stopped after a collision, the movement node is paused, but the scene-level
action can still ask for new pipe pairs. Spawning should be tied to active
movement and fully initialized scene resources.

## Completed Scope

- Added `shouldSpawnPipes()` to check movement state and required pipe/bird
  resources before creating a pipe pair.
- Returned early from `spawnPipes()` when gameplay is stopped or setup is
  incomplete.
- Extended the static baseline and docs so the pipe-spawn readiness contract
  remains visible.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
