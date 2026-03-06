// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "FitnessApp2",
    platforms: [.iOS(.v17)],
    targets: [
        .executableTarget(
            name: "FitnessApp2",
            path: "Sources/FitnessApp2",
            infoPlist: .init(stringLiteral: "Sources/FitnessApp2/Info.plist")
        )
    ]
)
