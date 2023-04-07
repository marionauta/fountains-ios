// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "DomainLayer",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "DomainLayer",
            targets: ["DomainLayer"]),
        .library(
            name: "WaterFountains",
            targets: ["WaterFountains"]),
    ],
    dependencies: [
        .package(name: "CommonLayer", path: "../CommonLayer"),
    ],
    targets: [
        .target(
            name: "DomainLayer",
            dependencies: [
                .byName(name: "CommonLayer"),
                .byName(name: "WaterFountains")
            ]),
        .binaryTarget(
            name: "WaterFountains",
            path: "../../android/WaterFountains/build/XCFrameworks/release/WaterFountains.xcframework"),
    ]
)
