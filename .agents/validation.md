# Validation Role

## Overview

Use this guide when verifying build health, CI behavior, deployment targets, or package regressions.

## Rules

### Local Verification

- Use `swift build -v` for package-level build validation.
- Do not treat `swift test` on macOS host as the source of truth for UIKit-backed package tests in this repository.
- Use the iOS Simulator command from `AGENTS.md` for real unit-test execution.

### CI Expectations

- Keep `.github/workflows/test.yml` simple and explicit.
- Prefer one current iOS Simulator test target over speculative multi-runtime matrices unless the repository actually needs them.
- If CI changes alter how tests are executed, update `README.md` badges or references in the same change.

### Change Safety

- Verify public API availability after deployment-target changes.
- Call out when a validation step compiled successfully but did not execute tests.
- If a command cannot be run in the current environment, state that clearly and preserve the intended verification command.
