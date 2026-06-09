---
title: Restart Resource Guard
date: 2026-06-09
status: completed
execution: code
---

## Context

Restart behavior already reset score value and score-label scale, and touch
handling routes through the shared active-gameplay guard. `resetScene()` still
assumed the bird, pipe container, movement node, and score label had all been
initialized before restart work began.

## Goals

- Guard required scene resources before reset work starts.
- Preserve existing restart behavior when the scene is fully initialized.
- Keep score value and score-label scale reset behavior unchanged.
- Extend static verification and docs for the restart resource boundary.

## Implementation

- Added a `guard let` block for the bird, pipes, moving node, and score label.
- Kept existing bird position, physics, pipe clearing, score, and movement
  reset behavior behind the guard.
- Extended `scripts/check-baseline.sh`, README, SECURITY, VISION, and CHANGES.

## Verification

- `sh -n scripts/check-baseline.sh`
- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`

Full Xcode verification still requires a macOS/Xcode environment.
