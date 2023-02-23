// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SBQuickLook",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SBQuickLook",
            targets: ["SBQuickLook"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SBQuickLook",
            dependencies: [],
            exclude: ["Examples"]),
        .testTarget(
            name: "SBQuickLookTests",
            dependencies: ["SBQuickLook"]),
    ]
)
