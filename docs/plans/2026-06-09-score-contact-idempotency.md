# Score Contact Idempotency

status: completed

## Context

`GameScene.didBeginContact` increments the score when either physics body belongs
to a score sensor. The score sensor can remain in contact for more than one
physics callback while the pipe pair moves past the bird, so one scoring zone
should be disabled after its first hit.

## Completed Scope

- Added a focused helper that identifies the score-contact node from either
  contact body.
- Cleared the score node physics body and removed the score sensor immediately
  after scoring so the same sensor cannot increment the score again.
- Extended the static baseline and docs to preserve the one-score-per-sensor
  contract.

## Verification

- `make check`
- `git diff --check`

## Follow-Ups

- Add runtime SpriteKit tests around scoring if the project is migrated to a
  modern Swift test harness.
