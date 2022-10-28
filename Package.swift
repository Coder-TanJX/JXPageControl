// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JXPageControl",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "JXPageControl",
            targets: ["JXPageControl"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "JXPageControl",
            dependencies: [
            ], path: "JXPageControl/Classes"
        )
    ]
)
