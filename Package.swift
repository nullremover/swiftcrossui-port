// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MishCrossUI",
    products: [
        .executable(name: "MishCrossUI", targets: ["MishCrossUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/moreSwift/swift-cross-ui", .upToNextMinor(from: "0.9.0"))
    ],
    targets: [
        .executableTarget(
            name: "MishCrossUI",
            dependencies: [
                .product(name: "SwiftCrossUI", package: "swift-cross-ui"),
                .product(name: "DefaultBackend", package: "swift-cross-ui")
            ],
            path: "Sources/MishCrossUI",
            linkerSettings: [
                .linkedLibrary("winmm", .when(platforms: [.windows]))
            ]
        )
    ]
)
