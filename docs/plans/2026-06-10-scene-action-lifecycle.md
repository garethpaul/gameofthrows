# Scene Action Lifecycle

status: completed

## Context

`GameScene` owns an infinite pipe-spawn action. Its run-block closure captures
the scene strongly, creating a scene -> action -> closure -> scene retention
cycle if the view controller replaces or dismisses the scene. The scene also
leaves keyed visual actions and its physics contact delegate active when it
moves away from an `SKView`.

## Priority

SpriteKit scenes retain textures, physics bodies, and node graphs. Releasing
those resources when a scene is no longer presented prevents hidden memory and
callback retention during view or scene transitions.

## Implementation

- Capture the scene weakly from the repeating pipe-spawn closure.
- Run the repeating spawn action under a stable key.
- Remove the spawn and flash actions when the scene leaves its view.
- Clear the physics contact delegate during scene teardown.
- Extend the static baseline and lifecycle documentation.

## Verification

- `sh -n scripts/check-baseline.sh`
- `make check`
- `make lint`
- `make test`
- `make build`
- `git diff --check`
- Mutations restoring strong spawn capture or removing teardown must fail.
- Hosted macOS Xcode project validation.

Full runtime verification still requires a compatible Xcode and iOS simulator
environment.
