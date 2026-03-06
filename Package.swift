// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FitnessApp2",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "FitnessApp2", targets: ["FitnessApp2"])
    ],
    targets: [
        .target(
            name: "FitnessApp2",
            path: "Sources/FitnessApp2",
            swiftSettings: [
                .unsafeFlags(["-swift-version", "5"])
            ]
        )
    ]
)
