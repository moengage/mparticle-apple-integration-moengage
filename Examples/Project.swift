import ProjectDescription

let defaultSettings: SettingsDictionary = [:]
    .codeSignIdentity("iPhone Developer")
    .merging([
        "GENERATE_INFOPLIST_FILE": true
    ])

let project = Project(
    name: "MoEngage",
    packages: [
        .local(path: "../")
    ],
    targets: [
        // Sample Apps
        .target(
            name: "MoEngageCocoaApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.alphadevs.MoEngage",
            deploymentTargets: .iOS("13.0"),
            infoPlist: "MoEngageApp/Info.plist",
            sources: ["MoEngageApp/**/*.{swift,h,m}"],
            resources: [
                "MoEngageApp/**/*.{xcassets,png,gpx,wav,mp3,ttf}",
                "MoEngageApp/iOS/**/*.{xib,storyboard}"
            ],
            headers: .headers(public: "MoEngageApp/**/*.h"),
            entitlements: "MoEngageApp/MoEngageApp.entitlements",
            settings: .settings(
                base: defaultSettings
                    .marketingVersion("1.0.0")
                    .currentProjectVersion("1.0.0")
            )
        ),
        .target(
            name: "MoEngageCocoaTVApp",
            destinations: .tvOS,
            product: .app,
            bundleId: "com.moengage.MoETVTest",
            deploymentTargets: .tvOS("13.0"),
            infoPlist: "MoEngageApp/Info.plist",
            sources: ["MoEngageApp/**/*.{swift,h,m}"],
            resources: [
                "MoEngageApp/**/*.{xcassets,png,gpx,wav,mp3,ttf}",
                "MoEngageApp/tvOS/**/*.{xib,storyboard}"
            ],
            headers: .headers(public: "MoEngageApp/**/*.h"),
            entitlements: "MoEngageApp/MoEngageApp.entitlements",
            settings: .settings(
                base: defaultSettings
                    .marketingVersion("1.0.0")
                    .currentProjectVersion("1.0.0")
            )
        ),
        .target(
            name: "MoEngageSPMApp",
            destinations: [.iPhone, .appleTv],
            product: .app,
            bundleId: "com.alphadevs.MoEngage",
            deploymentTargets: .multiplatform(iOS: "13.0", tvOS: "13.0"),
            infoPlist: "MoEngageApp/Info.plist",
            sources: ["MoEngageApp/**/*.{swift,h,m}"],
            resources: [
                "MoEngageApp/**/*.{xcassets,png,gpx,wav,mp3,ttf}",
                .glob(pattern: "MoEngageApp/iOS/**/*.{xib,storyboard}", inclusionCondition: .when([.ios]))
                ,
                .glob(pattern: "MoEngageApp/tvOS/**/*.{xib,storyboard}", inclusionCondition: .when([.tvos]))
                ,
            ],
            headers: .headers(public: "MoEngageApp/**/*.h"),
            entitlements: "MoEngageApp/MoEngageApp.entitlements",
             dependencies: [
                .package(product: "mParticle-MoEngage", type: .runtime)
             ],
            settings: .settings(
                base: defaultSettings
                    .marketingVersion("1.0.0")
                    .currentProjectVersion("1.0.0")
            )
        ),
    ],
    additionalFiles: ["../Utilities", "../Rakefile", "../LICENSE", "../package.json", "../*.md"],
    resourceSynthesizers: []
)