// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "swiftui-alert-advance",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "AlertAdvance",
            targets: ["AlertAdvance"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AlertAdvance",
            path: "Sources"
        ),
        .testTarget(
            name: "AlertAdvanceTests",
            dependencies: ["AlertAdvance"],
            path: "Tests"
        )
    ]
)
