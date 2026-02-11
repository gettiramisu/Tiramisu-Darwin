// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "TiramisuCore",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "TiramisuCore", targets: ["TiramisuCore"])
    ],
    dependencies: [
        .package(name: "Logger", path: "/Users/alexandra/Desktop/Coding/Logger-Darwin/")
    ],
    targets: [
        .target(name: "TiramisuCore", dependencies: ["Logger"])
    ]
)
