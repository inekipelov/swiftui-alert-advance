# Alert Advance

[![Swift Version](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Swift Tests](https://github.com/inekipelov/swiftui-alert-advance/actions/workflows/ci.yml/badge.svg)](https://github.com/inekipelov/swiftui-alert-advance/actions/workflows/swift.yml)  
[![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)](https://developer.apple.com/ios/)

Embed SwiftUI views inside `UIAlertController` alerts and action sheets with simple `alertContent` and `confirmationDialogContent` modifiers.

## Highlights
- Custom SwiftUI content inside `UIAlertController`.
- Drop-in modifiers – no need to rework existing alerts or confirmation dialogs.

## Preview
<table>
  <tr>
    <td align="center">Alert content</td>
    <td align="center">Confirmation dialog content</td>
  </tr>
  <tr>
    <td align="center">
      <img src="Resources/alert.gif" alt="Alert preview" width="320" style="object-fit: contain;" />
    </td>
    <td align="center">
      <img src="Resources/confirmationDialog.gif" alt="Confirmation dialog preview" width="320"style="object-fit: contain;" />
    </td>
  </tr>
</table>

## Usage

```swift
import SwiftUI
import AlertAdvance

struct ContentView: View {
    @State private var showAlert = false
    @State private var showSheet = false

    var body: some View {
        VStack(spacing: 16) {
            Button("Show alert") { showAlert = true }
                .alert("Title", isPresented: $showAlert) {
                    Button("OK") {}
                }
                .alertContent(isPresented: $showAlert) {
                    VStack {
                        Text("Custom alert content")
                        ProgressView()
                    }
                    .padding()
                }

            Button("Show confirmation") { showSheet = true }
                .confirmationDialog("Title", isPresented: $showSheet) {
                    Button("Action") {}
                }
                .confirmationDialogContent(isPresented: $showSheet) {
                    VStack {
                        Text("Custom sheet content")
                        Image(systemName: "hand.thumbsup.fill")
                    }
                    .padding()
                }
        }
        .padding()
    }
}
```
## Installation

Add via Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/inekipelov/swiftui-alert-advance.git", from: "0.1.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "AlertAdvance", package: "swiftui-alert-advance")
        ]
    )
]
```