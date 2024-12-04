import ProjectDescription

let defaultSettings: SettingsDictionary = [:]
    .codeSignIdentity("iPhone Developer")
    .merging([
        "GENERATE_INFOPLIST_FILE": true
    ])

let project = Project(
    name: "MoEngagemParticle",
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
            dependencies: [
                .target(name: "NotificationService", condition: nil),
                .target(name: "NotificationContent", condition: nil),
            ],
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
                .package(product: "mParticle-MoEngage", type: .runtime),
            ],
            settings: .settings(
                base: defaultSettings
                    .marketingVersion("1.0.0")
                    .currentProjectVersion("1.0.0")
            )
        ),

        // Extensions
        .target(
            name: "NotificationService",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "com.alphadevs.MoEngage.NotificationService",
            deploymentTargets: .iOS("13.0"),
            infoPlist: "NotificationService/Info.plist",
            sources: ["NotificationService/**/*.{swift,h,m}"],
            entitlements: "NotificationService/NotificationService.entitlements",
            dependencies: [],
            settings: .settings(
                base: defaultSettings
                    .marketingVersion("1.0.0")
                    .currentProjectVersion("1.0.0")
            )
        ),
        .target(
            name: "NotificationContent",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "com.alphadevs.MoEngage.NotificationContent",
            deploymentTargets: .iOS("13.0"),
            infoPlist: "NotificationContent/Info.plist",
            sources: ["NotificationContent/**/*.{swift,h,m}"],
            resources: ["NotificationContent/**/*.{xib,storyboard,xcassets}"],
            entitlements: "NotificationContent/NotificationContent.entitlements",
            dependencies: [],
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
