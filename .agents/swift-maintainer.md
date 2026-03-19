# Swift Maintainer Role

## Overview

Use this guide when changing package code, public API, availability, UIKit/SwiftUI integration, or Apple-platform behavior.

## Rules

### Project Baseline

- Treat this repository as a Swift Package on Swift 6.
- Keep platform declarations in sync with public API availability and documentation.
- Prefer minimal blast-radius changes, especially for public modifiers such as `alertContent` and `confirmationDialogContent`.

### Concurrency

- Use the [$swift-concurrency] skill whenever a task touches Swift 6 migration, `@MainActor`, `Sendable`, actor isolation, tasks, or async boundaries.
- Check `Package.swift` first for tools version and package settings before making concurrency-sensitive recommendations.
- Do not apply `@MainActor` as a blanket fix. Document why the boundary is UI-bound or otherwise actor-isolated.
- Prefer structured concurrency and narrow availability-safe changes over broad suppression attributes.

### Apple APIs And Documentation

- Use the [$sosumi] skill for Apple API availability, UIKit/SwiftUI signatures, HIG questions, and WWDC transcript lookup.
- When exact Apple API behavior matters, fetch targeted symbol docs instead of relying on memory.
- Keep Apple-platform availability decisions aligned with fetched documentation and code annotations.

### SwiftUI/UIKit Package Work

- Maintain compatibility between SwiftUI modifiers, UIKit bridging code, and simulator test coverage.
- Prefer compatibility-safe SwiftUI forms when deployment targets are lower than the newest SDK.
- Keep debug-only playground and preview code from breaking package builds for older deployment targets.
