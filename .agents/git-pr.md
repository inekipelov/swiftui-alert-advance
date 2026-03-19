# Git And PR Rules

## Overview

Use this guide for branch hygiene, commit messages, pull requests, and review preparation.

## Rules

### Commits

- Prefer focused commits with imperative subjects.
- Subject line should be concise, imperative, and without trailing period.
- Keep the subject line within 72 characters.
- Separate subject and body with a blank line when a body is needed.
- Wrap body lines at about 72 characters and explain why, not only what changed.

### Pull Requests

- Before opening a PR, ensure the package build and current iOS Simulator tests pass.
- Summaries should mention user-visible behavior changes, compatibility changes, and CI/workflow updates.
- If a PR changes deployment targets, availability, or Apple API usage, mention that explicitly in the PR description.

### Gitlint

- Treat gitlint compliance as required for PR-ready history.
- If `gitlint` is installed, run `gitlint --commits origin/main..HEAD` before creating or updating a PR.
- If the branch is not based on `main`, lint the actual commit range against the merge base instead of forcing a wrong range.
- Fix gitlint violations by rewriting the commit message, not by weakening the rule in the PR.
