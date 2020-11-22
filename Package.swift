// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "QRScanner",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "QRScanner",
            targets: ["QRScanner"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "QRScanner",
            dependencies: [],
            path: "QRScanner",
            exclude: [
                "Info.plist",
            ],
            linkerSettings: [
                .linkedFramework("AVFoundation"),
                .linkedFramework("UIKit"),
            ]
        ),
    ]
)
