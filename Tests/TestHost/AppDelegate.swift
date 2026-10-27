//
//  AppDelegate.swift
//  TestHost
//
//  Copyright © 2026 MoEngage Inc. All rights reserved.
//

import UIKit

/// Host app for the CocoaPods unit tests, which need a running application.
///
/// Replaces CocoaPods' generated `AppHost`, which has no scene support: apps built with
/// the iOS/tvOS 27 SDK must adopt the scene life cycle or UIKit traps at launch.
@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        return true
    }
}
