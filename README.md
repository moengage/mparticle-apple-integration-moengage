# MoEngage Kit Integration

![Logo](/.github/logo.png)

This repository contains the [MoEngage](https://www.moengage.com) integration for the [mParticle Apple SDK](https://github.com/mParticle/mparticle-apple-sdk).

## Adding the integration

1. Add the kit dependency to your app's Podfile, or SPM:

    ```rb
    pod 'mParticle-MoEngage', '~> 1.0.0'
    ```

    [![CocoaPods](https://img.shields.io/cocoapods/v/mParticle-MoEngage.svg?label=CocoaPods&color=C90005)](https://badge.fury.io/co/mParticle-MoEngage)

    OR

    > Open your project and navigate to the project's settings. Select the tab named Swift Packages and click on the add button (+) at the bottom left. then, enter the URL of MoEngage Kit GitHub repository - https://github.com/moengage/mparticle-apple-integration-moengage and click Next.

    [![Swift Package Manager](https://img.shields.io/github/v/tag/moengage/mParticle-MoEngage?label=SPM&color=orange)](https://badge.fury.io/gh/moengage%2FmParticle-MoEngage)

1. Disable MoEngageSDK method swizzling by setting `MoEngageAppDelegateProxyEnabled` as `false`/`NO` in app's `Info.plist`.

1. Configure MoEngage SDK

    ```swift
    let sdkConfig = MoEngageSDKConfig(appId: "YOUR APP ID", dataCenter: YOUR_DATA_CENTER)
    MoEngageConfigurator.configureInstance(sdkConfig: sdkConfig)
    ```

1. Follow the mParticle iOS SDK [quick-start](https://github.com/mParticle/mparticle-apple-sdk), then rebuild and launch your app, and verify that you see `"Included kits: { MoEngageSDK }"` in your Xcode console

    > (This requires your mParticle log level to be at least Debug)

1. Reference mParticle's integration docs below to enable the integration.

### Documentation

[MoEngage integration](https://docs.mparticle.com/integrations/moengage/event/)

### License

[License](LICENSE)
