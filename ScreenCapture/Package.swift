// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScreenCapture",
    platforms: [.macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ScreenCapture",
            targets: ["ScreenCapture"]),
    ], dependencies: [
        .package(url: "https://github.com/sindresorhus/KeyboardShortcuts.git", from: Version(stringLiteral: "2.0.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ScreenCapture",
            dependencies: [
                .product(name: "KeyboardShortcuts",package: "KeyboardShortcuts")
                ]
        ),
        .testTarget(
            name: "ScreenCaptureTests",
            dependencies: ["ScreenCapture"]),
    ]
)
