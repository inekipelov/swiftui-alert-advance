# swiftui-alert-advance

Swift Package that embeds SwiftUI content inside `UIAlertController` alerts and confirmation dialogs.

## Quick Reference

- Package manager: SwiftPM
- Build: `swift build -v`
- Tests: `xcodebuild -scheme swiftui-alert-advance -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max,OS=26.2' -skipPackagePluginValidation -skipMacroValidation test`
- CI workflow: `.github/workflows/test.yml`
- Default branch: `main`

## Universal Rules

- Do not make code changes until the user gives a clear, explicit instruction to do so.
- Preserve package compatibility targets declared in `Package.swift`.
- Prefer small, reviewable Swift 6 changes over broad refactors.
- Keep root instructions minimal; use the linked guides for task-specific rules.

## Detailed Guides

- [Planning Role](.agents/planning.md)
- [Swift Maintainer Role](.agents/swift-maintainer.md)
- [Validation Role](.agents/validation.md)
- [Git And PR Rules](.agents/git-pr.md)
