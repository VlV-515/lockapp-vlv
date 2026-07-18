// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "lockapp-vlv",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "Lockapp-vlv", targets: ["LockAppVLv"])
    ],
    targets: [
        .executableTarget(
            name: "LockAppVLv",
            path: "Sources/LockAppVLv"
        )
    ]
)
