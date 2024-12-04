//
//  AppDelegate.swift
//  MoEngageApp
//
//  Created by Soumya Ranjan Mahunt on 04/09/24.
//

import UIKit
import mParticle_Apple_SDK
import MoEngageSDK
import mParticle_MoEngage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    lazy var mParticle = MParticle.sharedInstance()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // UNUserNotificationCenter.current().delegate = self

        // Configure MoEngage
        MoEngageSDKCore.sharedInstance.enableAllLogs()
        let sdkConfig = MoEngageSDKConfig(appId: "YOUR APP ID", dataCenter: .data_center_01)
        sdkConfig.appGroupID = "group.com.alphadevs.MoEngage.NotificationServices"
        sdkConfig.consoleLogConfig = .init(isLoggingEnabled: true, loglevel: .verbose)
        MoEngageConfigurator.configureDefaultInstance(sdkConfig: sdkConfig)

        // Initialize mParticle
        let mParticleOptions = MParticleOptions(key: "Your API Key", secret: "Your Secret")
        // Disable AppDelegate proxy
        // mParticleOptions.proxyAppDelegate = false
        // Disable SSL pinning
        // mParticleOptions.networkOptions?.pinningDisabledInDevelopment = true

        mParticleOptions.logLevel = .verbose
        // Push mParticle logs to MoEngage
        // mParticleOptions.customLogger = { message in
        //     MoEngageLogger.logDefault(logLevel: .info, message: message, label: "mParticle")
        // }

        mParticleOptions.onAttributionComplete =  { attributionResult, error in
            if let error = error as? NSError {
                print("Attribution fetching for kitCode=\(String(describing: error.userInfo[mParticleKitInstanceKey])) failed with error=\(error)")
            }

            print("Attribution fetching for kitCode=\(String(describing: attributionResult?.kitCode)) completed with linkInfo: \(String(describing: attributionResult?.linkInfo))");
        }

        mParticle.start(with: mParticleOptions)

#if !os(tvOS)
        MoEngageSDKMessaging.sharedInstance.registerForRemoteNotification(withCategories: nil, andUserNotificationCenterDelegate: self)
#endif

        return true
    }
}

// MARK: Push Callback
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        mParticle.userNotificationCenter(center, didReceive: response)
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        mParticle.userNotificationCenter(center, willPresent: notification)
        completionHandler([.alert , .sound])
    }
}

// MARK: Navigation Callbacks
extension AppDelegate {
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([any UIUserActivityRestoring]?) -> Void) -> Bool {
        mParticle.continue(userActivity, restorationHandler: restorationHandler)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        mParticle.open(url, options: options)
        return true
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        mParticle.open(url)
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        mParticle.open(url, sourceApplication: sourceApplication, annotation: annotation)
        return true
    }
}

// MARK: Proxied methods
// Enable if proxy disabled
//extension AppDelegate {
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        mParticle.didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
//    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
//        mParticle.didFailToRegisterForRemoteNotificationsWithError(error)
//    }
//
//    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
//        //
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        mParticle.didReceiveRemoteNotification(userInfo)
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        mParticle.didReceiveRemoteNotification(userInfo)
//        completionHandler(.noData)
//    }
//
//    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
//        mParticle.handleAction(withIdentifier: identifier, forRemoteNotification: notification.userInfo)
//        completionHandler()
//    }
//}
