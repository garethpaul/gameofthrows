---
title: Preserve Death Rotation Ownership
type: reliability
date: 2026-06-14
status: completed
execution: code
---

# Preserve Death Rotation Ownership

## Summary

Stop the per-frame flight-orientation update once gameplay has ended so the
keyed death-rotation action remains the sole owner of bird rotation after a
fatal collision.

## Requirements

- R1. Return from `update` before reading bird physics when gameplay is stopped.
- R2. Keep active-gameplay flight orientation unchanged.
- R3. Preserve collision, restart, teardown, and action-cancellation behavior.
- R4. Add a mutation-sensitive static contract for guard placement and plan
  completion.

## Verification Plan

- Run the focused static contract and all four Make gates from the repository.
- Run the canonical gate through the absolute Makefile path from `/tmp`.
- Reject isolated mutations that remove, invert, or move the gameplay guard,
  remove the rotation assignment, weaken evidence, or remove the new contract.
- Audit shell syntax, plist/XML parsing, exact diff, artifacts, signing and
  credential patterns, project/dependency drift, and conflict markers.

## Platform Limitation

Xcode, SpriteKit, a simulator, and an iOS device are unavailable on this Linux
host. Swift compilation and visible gameplay behavior require hosted or manual
Apple-platform validation and will not be claimed from local static checks.

## Work Completed

- Added an active-gameplay return at the start of `update`, before bird physics
  access and flight-orientation assignment.
- Added a dedicated structural checker and wired it into the canonical baseline.
- Synchronized contributor, change, security, readme, and vision guidance.

## Verification Completed

- The focused structural checker passed.
- six isolated hostile mutations were rejected for removed, inverted, and
  misplaced guards; removed rotation assignment; incomplete plan evidence; and
  orphaned checker integration.
- `make check`, `make lint`, `make test`, and `make build` passed at repository
  root.
- The full gate passed through the absolute Makefile path from `/tmp`.
- Shell syntax, plist/XML parsing, exact diff, artifacts, signing and credential
  patterns, project/workflow drift, whitespace, and conflict markers passed.
- Xcode, SpriteKit, simulator, device, and gameplay execution were unavailable
  on this Linux host and are not claimed.
