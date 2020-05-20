// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "ContactFinder",
    products: [
        .library(name: "ContactFinder", targets: ["App"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentPostgreSQL", "Authentication", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

