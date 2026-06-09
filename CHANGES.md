# Changes

## 2026-06-08

- Removed each score sensor after its first contact so one pipe pair cannot
  increment the score multiple times.
- Routed touch input through a single guarded bird impulse so one touch event
  cannot apply duplicate flaps.
- Added `make check` and `scripts/check-baseline.sh` for static iOS project verification.
- Made `build.sh` POSIX-safe and configurable through Xcode environment overrides.
- Hardened scene loading, pipe spawning, and frame-update physics access.
- Replaced the placeholder UI test with a launch smoke assertion.
- Documented Xcode, simulator, asset, and generated-output expectations.
