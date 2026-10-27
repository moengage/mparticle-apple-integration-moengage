//
//  SceneDelegate.swift
//  MoEngageApp
//
//  Copyright © 2026 MoEngage Inc. All rights reserved.
//

import UIKit
import mParticle_Apple_SDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // Set by UIKit from `UISceneStoryboardFile` (Main.storyboard) in Info.plist.
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard scene is UIWindowScene else { return }

        // Cold launch: URLs / universal links are delivered via connection options
        // instead of the app delegate when using the scene life cycle.
        for context in connectionOptions.urlContexts {
            open(context)
        }
        if let userActivity = connectionOptions.userActivities.first {
            self.scene(scene, continue: userActivity)
        }
    }
}

// MARK: Navigation Callbacks
extension SceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for context in URLContexts {
            open(context)
        }
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        _ = MParticle.sharedInstance().continue(userActivity) { _ in }
    }

    private func open(_ context: UIOpenURLContext) {
        var options: [String: Any] = [:]
        if let sourceApplication = context.options.sourceApplication {
            options[UIApplication.OpenURLOptionsKey.sourceApplication.rawValue] = sourceApplication
        }
        MParticle.sharedInstance().open(context.url, options: options)
    }
}
