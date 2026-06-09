# Score Contact Bird Pairing

status: completed

## Context

`GameScene.scoreContactNode` identified the score sensor from either physics
body, but it did not also prove the other body was the bird. The current contact
masks make that true today, but future category changes should not accidentally
award points for a score sensor touching another physics body.

## Completed Scope

- Added a small category-match helper for physics bodies.
- Required score contacts to pair one score body with one bird body before
  returning the score node.
- Extended the static baseline and docs to preserve the explicit bird-score
  contact contract.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
