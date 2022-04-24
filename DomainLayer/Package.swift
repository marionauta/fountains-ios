// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "DomainLayer",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "DomainLayer",
            targets: ["DomainLayer"]),
    ],
    dependencies: [
        .package(name: "DataLayer", path: "../DataLayer"),
    ],
    targets: [
        .target(
            name: "DomainLayer",
            dependencies: [
                .byName(name: "DataLayer"),
            ]),
    ]
)
