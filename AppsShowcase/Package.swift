// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "AppsShowcase",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "AppsShowcase",
            targets: ["AppsShowcase"]),
    ],
    targets: [
        .target(
            name: "AppsShowcase"),
    ]
)
