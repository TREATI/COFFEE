// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "COFFEE",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "COFFEE",
            targets: ["COFFEE"]),
    ],
    dependencies: [
        .package(name: "Sliders", url: "https://github.com/spacenation/swiftui-sliders", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "COFFEE",
            dependencies: [.product(name: "Sliders", package: "Sliders")],
            resources: [.process("Resources")]
        )
    ]
)
