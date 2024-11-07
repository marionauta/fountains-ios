// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "DomainLayer",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "DomainLayer",
            targets: ["DomainLayer"]),
        .library(
            name: "OpenLocationsShared",
            targets: ["OpenLocationsShared"]),
    ],
    dependencies: [
        .package(url: "https://github.com/marionauta/HelperKit", exact: "0.9.0"),
    ],
    targets: [
        .target(
            name: "DomainLayer",
            dependencies: [
                .byName(name: "HelperKit"),
                .byName(name: "OpenLocationsShared"),
            ]),
        .binaryTarget(
            name: "OpenLocationsShared",
            path: "../../android/OpenLocationsShared/build/XCFrameworks/release/OpenLocationsShared.xcframework"),
    ]
)
