// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "TextRecognition",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "TextRecognition",
            type: .static,
            targets: ["TextRecognition"]
        ),
        .executable(
            name: "ocr",
            targets: ["ocr"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Brendonovich/swift-rs", from: "1.0.5")
    ],
    targets: [
        .target(
            name: "TextRecognition",
            dependencies: [
                .product(name: "SwiftRs", package: "swift-rs")
            ]
        ),
        .executableTarget(
            name: "ocr",
            dependencies: ["TextRecognition"]
        )
    ]
)
