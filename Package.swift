// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "FitnessApp2",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        // An xtool project should contain exactly one library product,
        // representing the main app.
        .library(
            name: "FitnessApp2",
            targets: ["FitnessApp2"]
        ),
    ],
    targets: [
        .target(
            name: "FitnessApp2"
        ),
    ]
)
