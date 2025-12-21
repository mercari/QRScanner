// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "QRScanner",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "QRScanner",
            targets: ["QRScanner"]
        ),
    ],
    targets: [
        .target(
            name: "QRScanner",
            path: "QRScanner",
            exclude: [
                "Info.plist",
            ],
            resources: [
                .process("Images.xcassets"),
                .copy("PrivacyInfo.xcprivacy"),
            ]
        ),
    ]
)
