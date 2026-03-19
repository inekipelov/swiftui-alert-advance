// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "swiftui-alert-advance",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "AlertAdvance",
            targets: ["AlertAdvance"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/inekipelov/swift-obfuscate-macro.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "AlertAdvance",
            dependencies: [
                .product(name: "Obfuscate", package: "swift-obfuscate-macro")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "AlertAdvanceTests",
            dependencies: ["AlertAdvance"],
            path: "Tests"
        )
    ]
)
