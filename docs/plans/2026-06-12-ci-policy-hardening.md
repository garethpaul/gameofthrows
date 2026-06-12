---
title: Harden hosted workflow policy
status: completed
date: 2026-06-12
---

# Harden hosted workflow policy

## Goal

Keep the legacy SpriteKit sample's hosted validation bounded, reproducible, and
unable to expose the checkout credential to later steps.

## Changes

- Pin `actions/checkout` to the immutable v6.0.3 commit.
- Set `persist-credentials: false` and retain repository-wide read-only
  permissions.
- Keep `check.yml` as the only hosted workflow.
- Compare the entire workflow against one canonical definition so duplicate
  jobs, extra actions, conditionals, permission overrides, or alternate commands
  cannot bypass the local policy.
- Assign repository-wide review ownership in `.github/CODEOWNERS`.

## Verification

- `make check`
- `make lint`
- `make test`
- `make build`
- `git diff --check`
- Isolated hostile workflow mutations covering persisted credentials, extra
  steps, duplicate permissions, mutable action references, and hidden workflow
  files; every mutation must fail.
