// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "DataLayer",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "WaterFountains",
            targets: ["WaterFountains"]),
    ],
    targets: [
        .binaryTarget(
            name: "WaterFountains",
            path: "../../android/WaterFountains/build/XCFrameworks/release/WaterFountains.xcframework")
    ]
)
