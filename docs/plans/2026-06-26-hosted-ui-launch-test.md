# Hosted UI Launch Test

status: completed

## Context

The Xcode 16.4 modernization restored a real generic-simulator application
build, but deliberately left simulator launch as follow-up work. The shared UI
test scheme and isolated `build.sh` entry point already exist; hosted CI only
called `make check`, so it never executed them.

GitHub's maintained `macos-15` runner image documents Xcode 16.4, the iOS 18.5
simulator runtime, and an iPhone 16 Pro device. The canonical image inventory is
https://github.com/actions/runner-images/blob/main/images/macos/macos-15-Readme.md.

## Design

1. Preserve `make check` as the portable static/generic-build baseline.
2. Add one hosted-only step after the baseline.
3. Invoke the existing `build.sh` instead of duplicating Xcode arguments.
4. Pin `IOS_DESTINATION` to `platform=iOS Simulator,name=iPhone 16 Pro,OS=18.5`.
5. Keep the workflow read-only, credential-free, single-job, and ten-minute
   bounded.

## Alternatives

- Running simulator tests inside every `make check` was rejected because it
  would make the portable baseline depend on a bootable Apple runtime.
- Adding a second workflow was rejected because the repository intentionally
  keeps one canonical hosted gate and validates that ownership statically.
- Choosing an unversioned simulator destination was rejected because runner
  image changes could silently alter the runtime under test.

## Validation

- A baseline-first mutation fails while the hosted UI-test step is absent.
- Local `make check` verifies the exact workflow and documentation contract.
- Hosted Check runs `28271229926` and `28271230831` proved the pinned simulator
  boots and the UI launch smoke test passes on commit
  `99b51a81dc25b0a294760d7c64ae6a9cccb44735`.
- PR #18 merged that exact head as merge commit
  `5e610bbfccdf27a47e50f9a1f5abbb1c2851536a`.

## Scope

The launch test proves the application starts. It does not prove SpriteKit
rendering, touch input, collision timing, scoring, restart behavior, or device
hardware behavior.
