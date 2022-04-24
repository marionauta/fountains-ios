// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "DomainLayer",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "DomainLayer",
            targets: ["DomainLayer"]),
    ],
    dependencies: [
        .package(name: "CommonLayer", path: "../CommonLayer"),
        .package(name: "DataLayer", path: "../DataLayer"),
    ],
    targets: [
        .target(
            name: "DomainLayer",
            dependencies: [
                .byName(name: "CommonLayer"),
                .byName(name: "DataLayer"),
            ]),
    ]
)
