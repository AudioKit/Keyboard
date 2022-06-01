// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Keyboard",
    platforms: [ .macOS(.v12), .iOS(.v15)],
    products: [
        .library(
            name: "Keyboard",
            targets: ["Keyboard"]),
    ],
    dependencies: [.package(url: "https://github.com/Audulus/Tonic.git", branch: "main")],
    targets: [
        .target(
            name: "Keyboard",
            dependencies: []),
        .testTarget(
            name: "KeyboardTests",
            dependencies: ["Keyboard"]),
    ]
)
