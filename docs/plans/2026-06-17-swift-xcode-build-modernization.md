---
title: Modernize GameOfThrows for hosted Xcode builds
type: modernization
date: 2026-06-17
status: planned
execution: code
---

# Modernize GameOfThrows for hosted Xcode builds

## Context

The repository preserves a Swift 2-era SpriteKit sample, but its canonical
`macos-15` workflow only parses the Xcode project. The current runner image uses
Xcode 16.4 by default, while the app still uses Swift 2 method names, UIKit and
SpriteKit APIs, project migration metadata, and iOS 9 deployment targets. A
green workflow therefore does not prove that the application target compiles.

The existing gameplay lifecycle stack is well covered by order-sensitive
static contracts. The next engineering priority is to make those same sources
compile on the maintained hosted Apple toolchain without changing gameplay.

## Prioritized Engineering Tasks

1. **Selected: restore a real hosted application build.** Modernize the Swift
   syntax, project language mode, deployment floor, and maintenance gate so CI
   compiles the app with Xcode 16.4.
2. **Follow-up: execute the UI launch test on a pinned available simulator.**
   Keep this separate because simulator availability and boot time have a
   different reliability boundary from compilation.
3. **Follow-up: extract deterministic gameplay policy tests.** Move collision,
   scoring, and restart decisions behind Foundation-only seams before adding a
   modern unit-test target.

## Requirements

- Convert `AppDelegate`, scene loading, SpriteKit lifecycle callbacks, action
  APIs, geometry constructors, physics properties, touch handling, and the UI
  launch test to Swift 5-compatible syntax.
- Preserve the existing gameplay constants, contact pairing, scoring order,
  pipe timing, restart behavior, teardown ordering, weak spawn ownership, and
  keyed-action cancellation contracts.
- Set an explicit Swift 5 language mode for both application and UI-test
  targets.
- Raise all iOS deployment targets from the unsupported iOS 9 range to iOS 12,
  without changing device-family or signing assumptions.
- Pin the hosted workflow to the installed Xcode 16.4 developer directory
  instead of relying on the runner's mutable default selection.
- When `xcodebuild` is available, make the maintained baseline perform a
  code-signing-disabled Debug build of the `GameOfThrows` scheme for a generic
  iOS Simulator destination rather than only listing the project.
- Keep Linux verification truthful: syntax, source, project, documentation,
  and mutation contracts run locally while the actual Apple build remains a
  hosted macOS authority.
- Update maintained guidance and change history for the new supported
  toolchain and verification boundary.

## Implementation Units

### 1. Modernize application and UI-test sources

Files:

- `GameOfThrows/AppDelegate.swift`
- `GameOfThrows/GameViewController.swift`
- `GameOfThrows/GameScene.swift`
- `GameOfThrowsUITests/GameOfThrowsUITests.swift`

Adopt current Swift spellings and SpriteKit/UIKit signatures while retaining
the existing class structure and behavior. Replace the custom keyed-unarchiver
extension with SpriteKit's typed scene-file loading path. Keep optional-safe
scene and view handling.

### 2. Declare the maintained Xcode compatibility boundary

Files:

- `GameOfThrows.xcodeproj/project.pbxproj`
- `GameOfThrows.xcodeproj/xcshareddata/xcschemes/GameOfThrows.xcscheme`
- `GameOfThrows.xcodeproj/xcshareddata/xcschemes/GameOfThrowsUITests.xcscheme`

Set Swift 5 language mode and iOS 12 deployment targets for both targets.
Refresh migration metadata only where required for the current project format;
do not reorder unrelated project objects or regenerate the project wholesale.

### 3. Make compilation part of the canonical gate

Files:

- `scripts/check-baseline.sh`
- `.github/workflows/check.yml`
- `Makefile`

Preserve the existing static baseline, select Xcode 16.4 in the hosted workflow,
then run a bounded, code-signing-disabled application build against
`generic/platform=iOS Simulator` whenever Xcode is installed. Add
mutation-sensitive contracts for the Swift language mode, deployment floor,
current callback spellings, typed scene loading, pinned developer directory,
generic destination, and signing-disabled build.

### 4. Update maintenance guidance and evidence

Files:

- `AGENTS.md`
- `README.md`
- `SECURITY.md`
- `VISION.md`
- `CHANGES.md`
- `docs/plans/2026-06-17-swift-xcode-build-modernization.md`

Document Xcode 16.4/Swift 5 compilation as the hosted baseline, retain the
Linux limitation, and record only verification that actually ran.

## Validation

- Run `sh -n scripts/check-baseline.sh` and `sh -n build.sh`.
- Run all four Make gates and external-directory `make check` on Linux, with a
  truthful Xcode skip.
- Reject isolated mutations to Swift 5 project settings, the iOS 12 floor,
  modern SpriteKit callback names, typed scene loading, the generic simulator
  destination, pinned Xcode developer directory, code-signing suppression, and
  completed plan evidence.
- Audit the exact diff, project-file structure, generated artifacts, conflict
  markers, executable modes, and credential-shaped additions.
- Require the canonical push and pull-request macOS jobs to compile the exact
  delivery head successfully before recording terminal evidence.

## Risks And Boundaries

- Linux cannot compile UIKit or SpriteKit; hosted Xcode is the compilation
  authority.
- Raising the deployment floor drops iOS 9 through iOS 11 support. Those
  releases are outside the current runner SDK's maintained compatibility
  boundary.
- A successful generic-simulator build proves source and project compilation,
  not simulator launch, physics timing, rendering, touch behavior, or device
  execution.
- This change does not adopt Swift 6 language mode, strict concurrency,
  SwiftUI, a new app lifecycle, or broad project regeneration.
- PR stacking remains intact; no predecessor is merged or closed by this work.

## Assumptions

- The canonical `macos-15` runner continues to expose Xcode 16.4 at
  `/Applications/Xcode_16.4.app` during this change.
- The storyboard and `GameScene.sks` resources remain authoritative and load
  through their existing target membership.
- Existing static lifecycle contracts remain useful regression evidence during
  the syntax migration and will be updated rather than weakened.

## Primary References

- GitHub Actions macOS 15 image inventory:
  `https://github.com/actions/runner-images/blob/main/images/macos/macos-15-Readme.md`
- Apple `SKScene` lifecycle documentation:
  `https://developer.apple.com/documentation/spritekit/skscene`
- Apple `SKPhysicsContactDelegate` documentation:
  `https://developer.apple.com/documentation/spritekit/skphysicscontactdelegate`
