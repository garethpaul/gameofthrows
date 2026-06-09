# Score Label Restart Reset

status: completed

## Context

The score label scales briefly when a score sensor is crossed. Restart already
resets the score value, bird position, pipes, and movement state, but it did not
explicitly reset the animated score label scale.

## Completed Scope

- Reset `scoreLabelNode` scale when the scene restarts.
- Extended the static baseline so restart keeps clearing score animation state.
- Documented the restart behavior in README, VISION, and CHANGES.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
