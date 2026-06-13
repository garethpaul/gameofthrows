---
title: Location-Independent GameOfThrows Verification
type: reliability
date: 2026-06-13
status: planned
execution: code
---

# Location-Independent GameOfThrows Verification

## Summary

Resolve the maintained static checker from the loaded Makefile so every
documented gate works when Make is invoked outside the checkout.

## Requirements

- R1. Derive the repository root from `MAKEFILE_LIST`.
- R2. Invoke `scripts/check-baseline.sh` through its repository-rooted path.
- R3. Add a static contract that rejects caller-directory-relative invocation.
- R4. Preserve all Swift, SpriteKit, Xcode project, plist, asset, workflow,
  signing, and gameplay behavior.
- R5. Record actual root and external-directory verification before completion.

## Implementation Units

### Rooted Make Entry Point

Update `Makefile` to derive the checkout root from the loaded Makefile and use
that root for the canonical checker recipe. Keep `lint`, `test`, and `build` as
aliases of the same maintained baseline.

### Verification Contract

Extend `scripts/check-baseline.sh` with exact rooted-Makefile and completed-plan
contracts. Synchronize the maintained command guidance without changing the
legacy application or Xcode project.

### Mutation Coverage

Exercise isolated hostile mutations for root derivation, checker invocation,
documentation, plan status, and recorded external verification.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build` at repository
  root.
- Run the full gate from `/tmp` through the absolute Makefile path.
- Reject isolated hostile root-derivation, checker-path, documentation,
  plan-status, and verification-evidence mutations.
- Run shell syntax, plist/XML parsing, `git diff --check`, exact-path review,
  secret/signing inspection, and generated-artifact inspection.

## Non-Goals

- Changing application runtime, dependencies, project settings, signing,
  SpriteKit lifecycle, collision handling, scoring, restart, or teardown logic.
- Claiming Xcode build, simulator, device, UI-test, or gameplay execution on
  this Linux host.

## Risks

- Recursive verification would occur if the checker launched Make while
  validating the external invocation; the contract will inspect the recipe and
  the top-level validation will execute the external gate.
- The legacy Apple runtime remains unverified locally because Xcode is not
  available.

## Work Completed

Pending implementation.

## Verification Completed

Pending implementation and validation.
