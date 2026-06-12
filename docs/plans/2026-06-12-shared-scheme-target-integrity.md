# Shared Scheme Target Integrity

status: completed

## Context

`GameOfThrows.xcscheme` included a testable reference to
`GameOfThrowsTests.xctest` with BlueprintIdentifier `4374520F193D163800654986`.
That target does not exist in `project.pbxproj`; the project contains only the
application and UI-test targets.

The hosted baseline parses the project with `xcodebuild -list`, but the local
static checks do not verify that every target referenced by a shared scheme is
still defined by the project. A stale test reference can therefore break the
scheme's Test action while the current gate remains green.

## Priority

Shared schemes are the checked-in build and test contract for contributors and
automation. Dangling BlueprintIdentifiers make that contract misleading and
can fail before the remaining launch test runs.

## Prioritized Backlog

1. Remove the orphaned `GameOfThrowsTests` entry from the app scheme.
2. Keep the existing `GameOfThrowsUITests` testable reference intact.
3. Make the static baseline reject every shared-scheme BlueprintIdentifier that
   is absent from `project.pbxproj`.
4. Document the repaired scheme contract and compatible-Xcode verification
   requirement.

## Implementation

- Edit only the stale `TestableReference` in `GameOfThrows.xcscheme`.
- Extract BlueprintIdentifiers from all checked-in shared schemes and require
  each identifier to appear in the Xcode project.
- Require the app scheme to retain the UI-test bundle reference and reject the
  removed legacy unit-test bundle name.
- Extend README, SECURITY, VISION, CHANGES, and the repository baseline.

## Verification

- `make check`
- `make lint`
- `make test`
- `make build`
- `sh -n scripts/check-baseline.sh`
- Parse both shared schemes as XML.
- `git diff --check`
- Mutations restoring the orphaned target or replacing a valid BlueprintIdentifier
  with an unknown value must fail.
- Run the scheme Test action on a compatible Xcode and iOS simulator before
  claiming runtime gameplay coverage.

## Work Completed

- Removed the orphaned `GameOfThrowsTests.xctest` reference while retaining
  the valid `GameOfThrowsUITests.xctest` reference in the shared app scheme.
- Added a static contract that resolves every shared-scheme
  `BlueprintIdentifier` against the native targets declared by
  `project.pbxproj`.
- Kept the compatible-Xcode requirement explicit so static project validation
  cannot be mistaken for runtime gameplay coverage.

## Verification Completed

- `make lint`, `make test`, `make build`, `make check`, shell syntax, both
  shared-scheme XML parses, and `git diff --check` passed locally. The local
  environment lacks Xcode, so this evidence is limited to the static baseline.
- Implementation push run `27392844491` and pull-request run `27392848940`
  passed at commit `e32d324639738acc6aaf2e8fcd2719a9704aa903`; the hosted
  macOS gate included `xcodebuild -list` project parsing.
- Post-merge push run `27392863018` and CodeQL run `27402320931` passed at
  default-branch merge commit `e0361e43735db41c9ebaff1d167f8b451506f7d4`.
- Mutations restoring the orphaned target or replacing a valid
  `BlueprintIdentifier` with an unknown target were rejected by `make check`.
  No simulator Test action or runtime gameplay coverage is claimed.
