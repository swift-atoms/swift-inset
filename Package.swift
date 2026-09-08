// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-inset",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [.library(name: "Inset", targets: ["Inset"])],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-vector.git", branch: "main"),
    ],
    targets: [
        .target(name: "Inset", dependencies: [.product(name: "Vector", package: "swift-vector")]),
        .testTarget(name: "Inset Tests", dependencies: [.target(name: "Inset")]),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
