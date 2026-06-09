# gameofthrows

<!-- README-OVERVIEW-IMAGE -->
![Project overview](docs/readme-overview.svg)

## Overview

`garethpaul/gameofthrows` is an Apple platform application or Objective-C/Swift sample. Game of Throws

This README is based on the checked-in source, manifests, scripts, and repository metadata on the `master` branch. The project language mix found during review was: Swift (4), shell (1).

## Repository Contents

- `README.md` - project overview and local usage notes
- `build.sh`
- `CHANGES.md` - concise history of maintenance changes
- `GameOfThrows` - source or example code
- `GameOfThrows.xcodeproj` - Xcode project file
- `GameOfThrowsUITests` - source or example code
- `Makefile` - local verification entry point
- `SECURITY.md` - security reporting and disclosure guidance
- `scripts/check-baseline.sh` - static SpriteKit/Xcode project checks
- `VISION.md` - project direction and maintenance guardrails

Additional scan context:

- Source directories: GameOfThrows, GameOfThrowsUITests
- Dependency and build manifests: none detected
- Entry points or build surfaces: build.sh, Makefile, GameOfThrows.xcodeproj
- Test-looking files: GameOfThrowsUITests/GameOfThrowsUITests.swift, GameOfThrowsUITests/Info.plist

## Getting Started

### Prerequisites

- Git
- macOS with Xcode for building Apple platform projects

### Setup

```bash
git clone https://github.com/garethpaul/gameofthrows.git
cd gameofthrows
```

The setup commands above are derived from repository files. Legacy mobile, Python, or JavaScript samples may require older SDKs or package versions than a modern workstation uses by default.

## Running or Using the Project

- Open `GameOfThrows.xcodeproj` in Xcode, choose the app or sample scheme, and run it on the matching simulator/device.
- Run `./build.sh` when the required platform toolchain is installed.

## Testing and Verification

- Run `make check` for static project, script, asset, and crash-hardening checks that do not require Xcode.
- The static baseline also preserves the score sensor contract: each pipe score
  zone removes itself after the first contact so a single pass cannot count
  twice.
- Score increments are limited to bird-score contacts, so future physics
  category changes cannot accidentally award points for non-player contacts.
- Touch handling applies one bird impulse per touch event and guards missing
  bird physics before flapping.
- Restart resets the score label scale as well as the score value so prior
  scoring animations do not carry into a new run.
- The pipe spawning loop is guarded so stopped gameplay or incomplete scene
  setup cannot add new pipe pairs.
- Xcode's test action or `xcodebuild test` with the appropriate scheme and destination
- Run `./build.sh` on macOS with Xcode installed. Set `IOS_SIMULATOR_NAME` to
  override only the simulator name, or `IOS_DESTINATION` to provide a full
  xcodebuild destination string.

When the required SDK or runtime is unavailable, use static checks and source review first, then verify on a machine that has the matching platform toolchain.

## Configuration and Secrets

- No required secret or credential file was identified in the repository scan. If you add integrations later, keep secrets out of git.

## Security and Privacy Notes

- Review changes touching network requests, sockets, or service endpoints; examples from the scan include GameOfThrows/Info.plist, GameOfThrowsUITests/Info.plist.
- Review changes touching file, media, JSON, XML, CSV, OCR, or data parsing; examples from the scan include GameOfThrows/Info.plist, GameOfThrowsUITests/Info.plist.

## Maintenance Notes

- This looks like an Apple platform project or sample. Xcode, Swift, CocoaPods, and deployment target versions may need to match the original project era.
- Run `make check` before pushing changes that touch SpriteKit scene loading,
  assets, build scripts, project files, or UI test setup.
- See `SECURITY.md` for vulnerability reporting and safe research guidance.
- See `VISION.md` for project direction and contribution guardrails.
- See `docs/plans/2026-06-09-single-tap-impulse-guard.md` for the tap impulse
  guard.
- See `docs/plans/2026-06-09-score-label-restart-reset.md` for the score label
  restart reset.
- See `docs/plans/2026-06-09-score-contact-bird-pairing.md` for the explicit
  score-contact pairing guard.
- See `docs/plans/2026-06-09-pipe-spawn-readiness-guard.md` for the pipe
  spawning readiness guard.

## Contributing

Keep changes small and tied to the project that is already present in this repository. For code changes, document the toolchain used, avoid committing generated dependency directories or local configuration, and update this README when setup or verification steps change.
