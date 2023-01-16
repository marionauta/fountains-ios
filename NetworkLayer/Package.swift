// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "NetworkLayer",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "NetworkLayer",
            targets: ["NetworkLayer"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "NetworkLayer",
            dependencies: []),
    ]
)
