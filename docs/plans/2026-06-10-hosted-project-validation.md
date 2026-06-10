# Hosted Project Validation

status: completed

## Context

The local baseline automatically ran the legacy iPhone 5 UI-test destination
whenever Xcode was installed. That simulator is not a stable current-Xcode
contract, while project parsing and the existing static SpriteKit checks are
credential-free and deterministic.

## Changes

- Changed `make check` on macOS to parse the checked-in Xcode project instead
  of automatically running the legacy simulator test script.
- Kept `build.sh` as the explicit functional test path for a compatible Xcode
  and simulator environment.
- Added pinned, least-privilege macOS GitHub Actions validation with a timeout
  and cancellation of superseded runs.

## Verification

- `make check`
- Workflow YAML parse
- Hosted `macos-15` GitHub Actions run
