## Game Of Throws Vision

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

Next priorities:

- Document Xcode and simulator expectations
- Add manual gameplay verification notes
- Expand tests around scene loading or score/state behavior where practical
- Modernize Swift/project settings in a dedicated pass

Contribution rules:

- One PR = one focused gameplay, asset, build, or documentation change.
- Verify the game launches and plays after scene or asset changes.
- Keep generated build products and signing files out of git.
- Include screenshots or notes for visible gameplay changes.

## Security

This is a local game sample. Future network, analytics, or leaderboard features
should be opt-in, documented, and avoid collecting unnecessary user data.

## What We Will Not Merge For Now

- Asset replacements without purpose or provenance
- Broad Swift migrations mixed with gameplay changes
- Analytics or tracking features
- Build changes that make the sample harder to open in Xcode
