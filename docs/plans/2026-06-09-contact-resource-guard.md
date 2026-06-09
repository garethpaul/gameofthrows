---
title: Contact Resource Guard
date: 2026-06-09
status: completed
execution: code
---

## Context

`didBeginContact` already checks that gameplay is active before scoring or
ending a run. The collision path still read implicitly unwrapped scene
resources directly, including the bird, moving node, score label, and sky
color, and the delayed bird-stop completion reached back through `self.bird`.

Physics callbacks should stop cleanly if required scene resources are not ready.

## Goals

- Guard required contact-handling resources before score or collision work.
- Use local references for the bird, moving node, score label, and sky color.
- Avoid reaching back through `self.bird` in the delayed collision completion.
- Extend the static baseline and docs for the contact-resource boundary.

## Implementation

- Added a `guard let` resource boundary after the active-gameplay check in
  `didBeginContact`.
- Updated scoring, collision stop, and flash reset logic to use the guarded
  local values.
- Extended README, SECURITY, VISION, CHANGES, and `scripts/check-baseline.sh`.

## Verification

- `sh -n scripts/check-baseline.sh`
- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`

Full Xcode build and simulator verification still require a macOS/Xcode
environment.
