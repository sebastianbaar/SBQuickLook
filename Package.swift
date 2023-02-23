// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SBQuickLook",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SBQuickLook",
            targets: ["SBQuickLook"]),
    ],
    targets: [
        .target(
            name: "SBQuickLook",
            dependencies: []),
        .testTarget(
            name: "SBQuickLookTests",
            dependencies: ["SBQuickLook"]),
    ]
)
