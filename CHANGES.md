# Changes

## 2026-06-10

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
