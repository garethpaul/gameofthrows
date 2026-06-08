# Game Of Throws SpriteKit Baseline Plan

status: completed

## Context

`gameofthrows` is a Swift 2-era SpriteKit side-scroller sample with an Xcode
project, UI test scheme, and a small shell build script. Local `xcodebuild`
is not available in this environment, so the practical baseline is static
validation plus source-level crash hardening.

## Objectives

- Add a reproducible `make check` command for static project validation.
- Keep the legacy build script usable while allowing simulator overrides.
- Reduce crash risk in scene loading and per-frame physics updates.
- Keep generated Xcode/Finder artifacts out of git.
- Document the verification path and remaining Xcode requirement.

## Work Items

1. Added `Makefile` and `scripts/check-baseline.sh`.
2. Made `GameScene.sks` unarchiving and `SKView` casting optional-safe.
3. Guarded bird physics-body access during frame updates.
4. Replaced modulo pipe spawn randomization with `arc4random_uniform`.
5. Updated `build.sh` to use POSIX shell syntax and configurable Xcode environment overrides.
6. Added a UI test launch smoke assertion.
7. Updated README, VISION, and CHANGES with the baseline.

## Verification

- `make check`
- `git diff --check`

## Follow-Ups

- Run `./build.sh` or Xcode UI tests on a macOS machine with a compatible iOS
  simulator.
- Modernize the Swift/project settings in a dedicated migration.
- Add unit-level scene tests if the project is moved to a modern Swift test
  harness.
