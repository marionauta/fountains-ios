// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "DataLayer",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "DataLayer",
            targets: ["DataLayer", "WaterFountains"]),
    ],
    targets: [
        .target(name: "DataLayer"),
        .binaryTarget(
            name: "WaterFountains",
            path: "../../android/WaterFountains/build/XCFrameworks/release/WaterFountains.xcframework")
    ]
)
