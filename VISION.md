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

- `scripts/check-baseline.sh` and `make check` validate shell syntax, plist
  presence, Xcode project shape, scene-loading guardrails, and SpriteKit physics
  safety checks.
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
- Restart resets score label scale so score animations do not leak into the
  next run.
- The pipe spawning path is guarded by movement state and required scene
  resources so stopped gameplay does not keep adding pipe pairs.
- UI tests keep a launch smoke test for basic app startup coverage.

Next priorities:

- Add manual gameplay verification notes
- Expand tests around scene loading or score/state behavior where practical
- Keep tap impulse and restart behavior covered by static checks until runtime
  tests are available
- Keep bird-score contact pairing covered while score behavior remains
  statically verified
- Keep score label scale reset behavior covered while score animations remain
  runtime-only
- Keep pipe spawning tied to active movement while the restart loop remains
  action-driven
- Modernize Swift/project settings in a dedicated pass

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
- Broad Swift migrations mixed with gameplay changes
- Analytics or tracking features
- Build changes that make the sample harder to open in Xcode

This list is a roadmap guardrail, not a permanent rule.
Strong user demand and strong technical rationale can change it.
