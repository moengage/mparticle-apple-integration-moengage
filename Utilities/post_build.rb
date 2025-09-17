#!/usr/bin/ruby

# Usage:
# Update Package.swift, version constants as per package.json

require 'json'
require 'ostruct'

config = JSON.parse(File.read('package.json'), {object_class: OpenStruct})

package_swift = <<PACKAGE
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
        .package(url: "https://github.com/mParticle/mparticle-apple-sdk", from: "#{config.mParticleVersionSPM}"),
        .package(url: "https://github.com/moengage/MoEngage-iOS-SDK.git", "#{config.sdkVerMin}"..<"#{config.sdkVerMax}")
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
PACKAGE

version_constant = <<CONSTANTS
// This file generated from post_build script, modify the script instaed of this file.
import Foundation

extension MPKitMoEngageConstant {
    static let moduleVersion = "#{config.packages[0].version}"
}
CONSTANTS

File.open('Package.swift', 'w') do |file|
  file.write(package_swift)
end

File.open('Sources/mParticle-MoEngage/mParticle_MoEngage+Version.swift', 'w') do |file|
  file.write(version_constant)
end
