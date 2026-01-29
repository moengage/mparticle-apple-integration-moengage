// swift-tools-version:5.7
// This file generated from post_build script, modify the script instaed of this file.

import PackageDescription

let package = Package(
    name: "mParticle-MoEngage",
    platforms: [.iOS(.v13), .tvOS(.v13)],
    products: [
        .library(name: "mParticle-MoEngage", targets: ["mParticle-MoEngage", "mParticle-MoEngageObjC"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mParticle/mparticle-apple-sdk", from: "8.27.1"),
        .package(url: "https://github.com/moengage/apple-sdk.git", "10.10.0"..<"10.11.0")
    ],
    targets: [
        .target(
            name: "mParticle-MoEngage",
            dependencies: [
                .product(name: "mParticle-Apple-SDK", package: "mparticle-apple-sdk"),
                .product(
                    name: Context.environment["MOENGAGE_KMM_FREE"] != nil ? "MoEngageSDK" : "MoEngage-iOS-SDK",
                    package: "apple-sdk"
                )
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
