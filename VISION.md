## Game Of Throws Vision

This document explains the current state and direction of the project.
Project overview and developer docs: [`README.md`](README.md)

Game Of Throws is a simple Swift SpriteKit game in the style of a flappy-bird
side-scroller.

The repository is useful as a compact iOS game sample with SpriteKit scenes,
texture atlases, storyboard setup, and UI test scaffolding. Setup notes live in
[`README.md`](README.md).

The goal is to keep the game playable, easy to build, and small enough to learn
from.

The current focus is:

Priority:

- Preserve the core tap/flight gameplay and SpriteKit scene structure
- Keep artwork and texture atlas files aligned
- Maintain basic Xcode project buildability
- Avoid broad gameplay rewrites without verification

Current baseline:

- GitHub Actions runs the static SpriteKit baseline and Xcode project parse on
  macOS; legacy simulator UI tests remain an explicit `build.sh` action.

- `scripts/check-baseline.sh`, `make lint`, `make test`, `make build`, and
  `make check` validate shell syntax, plist presence, Xcode project shape,
  scene-loading guardrails, and SpriteKit physics safety checks.
- `build.sh` uses POSIX shell syntax and supports `IOS_SIMULATOR_NAME` for
  simulator selection plus `IOS_DESTINATION` for full xcodebuild destination
  overrides.
- Scene loading and per-frame physics updates avoid the most crash-prone force
  unwraps.
- Touch handling applies one bird impulse per touch event and guards bird
  physics access before flapping.
- Score contacts enforce one score per pipe sensor by removing each score
  sensor after its first hit.
- Score increments require an explicit bird-score contact so unrelated physics
  bodies cannot award points if contact categories change later.
- Only explicit bird-world or bird-pipe contacts stop gameplay; unrelated
  physics contacts are ignored.
- Restart resets score label scale so score animations do not leak into the
  next run.
- Restart checks required scene resources before resetting bird position,
  clearing pipes, or updating score labels.
- Contact handling guards required scene resources before score or collision
  work.
- The pipe spawning path is guarded by movement state and required scene
  resources so stopped gameplay does not keep adding pipe pairs.
- Touch, contact, and pipe spawning paths share an active-gameplay guard before
  reading movement state.
- Scene presentation clears prior keyed actions and child nodes before rebuilding gameplay,
  keeping repeated presentation from duplicating interactive scene state.
- Presentation reset and view teardown cancel the bird's keyed death rotation before releasing child or delegate ownership.
- Restart cancels pending keyed collision work before restoring bird state so
  an earlier run cannot mutate the new round.
- Per-frame flight orientation stops when gameplay stops, leaving fatal-contact
  death rotation under one keyed action owner.
- The scene tears down repeating actions and its physics contact delegate when
  it leaves the SpriteKit view; the spawn closure does not retain the scene.
- View teardown revokes restart eligibility and stops the moving graph before
  releasing action and contact ownership, preventing late detached-scene work
  from restarting or mutating gameplay.
- The local Makefile exposes lint, test, build, and check targets for a stable
  pre-push gate.
- UI tests keep a launch smoke test for basic app startup coverage.
- Shared scheme BlueprintIdentifiers are validated against the Xcode project,
  and the app scheme contains only the existing UI-test bundle.

Next priorities:

- Add manual gameplay verification notes
- Expand tests around scene loading or score/state behavior where practical
- Keep tap impulse and restart behavior covered by static checks until runtime
  tests are available
- Keep bird-score contact pairing covered while score behavior remains
  statically verified
- Keep score label scale reset behavior covered while score animations remain
  runtime-only
- Keep restart resource checks covered while scene state remains implicitly
  unwrapped
- Keep contact resource checks in front of score and collision side effects
- Keep pipe spawning tied to active movement while the restart loop remains
  action-driven
- Keep local verification targets available even while full Xcode execution
  needs a macOS toolchain
- Keep hosted validation to one bounded, read-only workflow with an immutable
  checkout action and no persisted checkout credentials
- Keep touch, contact, and spawn decisions routed through the active-gameplay
  guard while movement state remains an implicitly unwrapped scene node
- Keep repeating action ownership weak and scene teardown explicit
- Keep teardown movement shutdown ahead of action and contact ownership cleanup
- Keep shared schemes free of dangling project target references
- Keep the completed Swift 5, iOS 12, and hosted Xcode 16.4 build boundary
  explicit and mutation-tested

Contribution rules:

- One PR = one focused gameplay, asset, build, or documentation change.
- Verify the game launches and plays after scene or asset changes.
- Keep generated build products and signing files out of git.
- Include screenshots or notes for visible gameplay changes.

## Security

Canonical security policy and reporting:

- [`SECURITY.md`](SECURITY.md)

This is a local game sample. Future network, analytics, or leaderboard features
should be opt-in, documented, and avoid collecting unnecessary user data.

## What We Will Not Merge (For Now)

- Asset replacements without purpose or provenance
- Broad Swift or project migrations mixed with gameplay changes
- Analytics or tracking features
- Build changes that make the sample harder to open in Xcode

This list is a roadmap guardrail, not a permanent rule.
Strong user demand and strong technical rationale can change it.
