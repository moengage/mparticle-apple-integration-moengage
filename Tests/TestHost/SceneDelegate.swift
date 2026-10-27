//
//  SceneDelegate.swift
//  TestHost
//
//  Copyright © 2026 MoEngage Inc. All rights reserved.
//

import UIKit

/// Scene delegate for the test host.
///
/// Exposed to Objective-C under a fixed name so the `Info.plist` scene manifest
/// does not depend on the host's module name.
@objc(MoEngageTestHostSceneDelegate)
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
        self.window = window
    }
}
