// swift-tools-version:5.3
// This file generated from post_build script, modify the script instaed of this file.

import PackageDescription

let package = Package(
    name: "mParticle-MoEngage",
    platforms: [.iOS(.v11), .tvOS(.v11)],
    products: [
        .library(name: "mParticle-MoEngage", targets: ["mParticle-MoEngage", "mParticle-MoEngageObjC"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mParticle/mparticle-apple-sdk", from: "8.27.1"),
        .package(url: "https://github.com/moengage/MoEngage-iOS-SDK.git", "9.21.0"..<"9.22.0")
    ],
    targets: [
        .target(
            name: "mParticle-MoEngage",
            dependencies: [
                .product(name: "mParticle-Apple-SDK", package: "mparticle-apple-sdk"),
                .product(name: "MoEngage-iOS-SDK", package: "MoEngage-iOS-SDK")
            ]
        ),
        // ObjC target to load plugin
        .target(
            name: "mParticle-MoEngageObjC",
            dependencies: [
                "mParticle-MoEngage",
                .product(name: "mParticle-Apple-SDK", package: "mparticle-apple-sdk"),
            ]
        ),
        .testTarget(name: "mParticle-MoEngageTests", dependencies: ["mParticle-MoEngage"]),
    ]
)
