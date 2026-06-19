# Changes

## 2026-06-17

- Migrated the app and UI launch test from Swift 2-era syntax to Swift 5 while
  preserving the existing SpriteKit gameplay and lifecycle contracts.
- Raised both targets to iOS 12 and made the pinned Xcode 16.4 hosted gate
  compile the app for a generic simulator with code signing disabled.
- Made the manual UI-test script resolve the default project from the repository
  root and keep Xcode DerivedData in a temporary directory.

## 2026-06-16

- Revoked restart eligibility before scene teardown stops movement and releases
  callback ownership, preventing late touches from reactivating detached play.
- Stopped the moving gameplay graph before scene teardown releases keyed
  actions and physics contact ownership, so late callbacks fail the shared
  active-gameplay guard.

## 2026-06-14

- Stopped per-frame flight orientation after gameplay ends so the keyed death
  rotation remains the sole owner of bird rotation after a fatal collision.

## 2026-06-13

- Made static verification independent of the caller's working directory by
  resolving the baseline checker from the loaded Makefile.
- Cancelled the bird's keyed death rotation before scene presentation reset and view teardown cleanup.
- Cancelled the keyed death rotation before restart restores bird state,
  preventing a prior collision completion from stopping the new run's bird.
- Made repeated scene presentation clear prior keyed actions and child nodes
  before rebuilding the gameplay graph.
- Required explicit bird-world or bird-pipe pairing before contact handling can
  stop gameplay, leaving unrelated physics contacts without side effects.

## 2026-06-12

- Removed the app scheme's dangling `GameOfThrowsTests` reference and made the
  baseline reject shared-scheme target identifiers missing from the project.
- Preserved repository-specific agent instructions for the legacy Swift and
  SpriteKit maintenance workflow.
- Pinned checkout to the immutable v6.0.3 commit, disabled persisted checkout
  credentials, assigned repository ownership, and made the local baseline
  reject hidden workflows or any drift from the canonical hosted job.

## 2026-06-10

- Prevented the repeating pipe-spawn action from retaining inactive scenes and
  added explicit action/contact teardown when a scene leaves its view.
- Added pinned macOS GitHub Actions validation for the static SpriteKit
  baseline and Xcode project parse.
- Kept the obsolete iPhone 5 simulator test as an explicit `build.sh` action
  instead of running it automatically whenever Xcode is installed.

## 2026-06-09

- Guarded contact handling resources before score or collision side effects.
- Guarded restart scene resources before resetting bird, pipe, movement, and
  score-label state.
- Added `make lint`, `make test`, and `make build` aliases so local verification
  has the expected pre-push gate targets in addition to `make check`.
- Routed touch, contact, and spawn checks through a shared active-gameplay guard
  before reading movement state.
- Required score increments to come from explicit bird-score contacts so future
  physics category changes cannot award points for unrelated contacts.
- Guarded pipe spawning so stopped gameplay or incomplete scene setup cannot
  add new pipe pairs.

## 2026-06-08

- Removed each score sensor after its first contact so one pipe pair cannot
  increment the score multiple times.
- Reset the score label scale on restart so score animations do not carry into
  a new run.
- Routed touch input through a single guarded bird impulse so one touch event
  cannot apply duplicate flaps.
- Added `make check` and `scripts/check-baseline.sh` for static iOS project verification.
- Made `build.sh` POSIX-safe and configurable through Xcode environment overrides.
- Hardened scene loading, pipe spawning, and frame-update physics access.
- Replaced the placeholder UI test with a launch smoke assertion.
- Documented Xcode, simulator, asset, and generated-output expectations.
