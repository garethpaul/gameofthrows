# Single Tap Impulse Guard

status: completed

## Context

`touchesBegan` looped over every touch in the event and applied the bird impulse
inside that loop. A multi-touch event could therefore apply multiple velocity
resets and impulses in a single frame. The impulse path also depended on the
bird physics body being present.

## Completed Scope

- Added `applyBirdImpulse()` as the single guarded flap path.
- Guarded bird and physics-body access before applying velocity and impulse.
- Changed touch handling so one touch event applies at most one bird impulse.
- Extended the static baseline and docs to preserve this gameplay boundary.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
