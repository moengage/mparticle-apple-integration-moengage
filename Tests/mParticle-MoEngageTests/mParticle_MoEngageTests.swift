//
//  mParticle_MoEngageTests.swift
//
//
//  Created by Soumya Ranjan Mahunt on 04/09/24.
//

import Testing
import MoEngageSDK
import mParticle_Apple_SDK
@testable import mParticle_MoEngage

@Suite(.serialized)
final class mParticle_MoEngageTests {
    @Test
    func mParticleClassName() {
        let expectedString = "MPKitMoEngage"
        #expect(expectedString == NSStringFromClass(MPKitMoEngage.self))
    }

    @Test(.enabled(if: UIDevice.current.userInterfaceIdiom != .tv))
    func iOSEmptyConfig() throws {
        let kit = MPKitMoEngage()
        let result = kit.didFinishLaunching(withConfiguration: [:])
        #expect(result.returnCode == .requirementsNotMet)
        #expect(!kit.started)
        #expect(kit.settings == nil)
        #expect(kit.providerKitInstance == nil)

        let activity = NSUserActivity(activityType: "moengage")
        activity.webpageURL = .init(string: "https://moengage.com/")
        let event = MPEvent(name: "test", type: .click)!
        let userInfo: [String: Any] = ["moengage": ["cid": "test", "app_id": "abcde"], "app_extra": [:]]
        let results = [
            kit.setDeviceToken("token".data(using: .utf8)!),
            kit.failedToRegister(forUserNotifications: NSError(domain: "error", code: 1)),
            kit.receivedUserNotification(userInfo),
            kit.handleAction(withIdentifier: "action", forRemoteNotification: userInfo),
            kit.continue(activity, restorationHandler: { _ in }),
            kit.open(activity.webpageURL!, options: [:]),
            kit.open(activity.webpageURL!, sourceApplication: "app", annotation: nil),
            kit.onSetUserAttribute(.init()),
            kit.setUserAttribute("key", value: "value"),
            kit.setUserAttribute("key", values: ["value", "value1"]),
            kit.onIdentifyComplete(.init(), request: .init()),
            kit.onLoginComplete(.init(), request: .init()),
            kit.onLogoutComplete(.init(), request: .init()),
            kit.onModifyComplete(.init(), request: .init()),
            kit.logBaseEvent(event),
            kit.setATTStatus(.denied, withATTStatusTimestampMillis: nil),
            kit.setATTStatus(.authorized, withATTStatusTimestampMillis: nil),
            kit.setOptOut(true),
            kit.setOptOut(false),
            kit.setLocation(.init(latitude: 12.9716, longitude: 77.5946))
        ]

        for (index, result) in results.enumerated() {
            let line = #line - results.count - 3 + index
            let sourceLocation = SourceLocation(
                fileID: #fileID, filePath: #fileID,
                line: line, column: #column
            )
            #expect(!result.success, sourceLocation: sourceLocation)
            #expect(result.returnCode == .requirementsNotMet, sourceLocation: sourceLocation)
            #expect(result.integrationId == MPKitMoEngageConstant.kitCode as NSNumber, sourceLocation: sourceLocation)
        }
    }

    @Test(.enabled(if: UIDevice.current.userInterfaceIdiom != .tv))
    func iOSValidConfig() async throws {
        let kit = MPKitMoEngage()
        let config = [MPKitMoEngageConstant.workspaceId: "abcde"]
        let stream = AsyncStream { continuation in
            var observer: Any!
            observer = NotificationCenter.default.addObserver(
                forName: .mParticleKitDidBecomeActive,
                object: nil, queue: .main
            ) { notification in
                continuation.yield(())
                NotificationCenter.default.removeObserver(observer as Any)
                continuation.finish()
            }
        }

        let result = kit.didFinishLaunching(withConfiguration: config)
        for await _ in stream { break }
        #expect(result.returnCode == .success)
        #expect(kit.started)
        #expect(kit.settings?.workspaceId == "abcde")
        #expect(kit.providerKitInstance as? MoEngage == MoEngage.sharedInstance)

        let activity = NSUserActivity(activityType: "moengage")
        activity.webpageURL = .init(string: "https://moengage.com/")
        let event = MPEvent(name: "test", type: .click)!
        let userInfo: [String: Any] = ["moengage": ["cid": "test", "app_id": "abcde"], "app_extra": [:]]
        let results = [
            kit.setDeviceToken("token".data(using: .utf8)!),
            kit.failedToRegister(forUserNotifications: NSError(domain: "error", code: 1)),
            kit.receivedUserNotification(userInfo),
            kit.handleAction(withIdentifier: "action", forRemoteNotification: userInfo),
            kit.continue(activity, restorationHandler: { _ in }),
            kit.open(activity.webpageURL!, options: [:]),
            kit.open(activity.webpageURL!, sourceApplication: "app", annotation: nil),
            kit.onSetUserAttribute(.init()),
            kit.setUserAttribute("key", value: "value"),
            kit.setUserAttribute("key", values: ["value", "value1"]),
            kit.onIdentifyComplete(.init(), request: .init()),
            kit.onLoginComplete(.init(), request: .init()),
            kit.onLogoutComplete(.init(), request: .init()),
            kit.onModifyComplete(.init(), request: .init()),
            kit.logBaseEvent(event),
            kit.setATTStatus(.denied, withATTStatusTimestampMillis: nil),
            kit.setATTStatus(.authorized, withATTStatusTimestampMillis: nil),
            kit.setOptOut(true),
            kit.setOptOut(false),
            kit.setLocation(.init(latitude: 12.9716, longitude: 77.5946))
        ]

        for (index, result) in results.enumerated() {
            let line = #line - results.count - 3 + index
            let sourceLocation = SourceLocation(
                fileID: #fileID, filePath: #fileID,
                line: line, column: #column
            )
            #expect(result.success, sourceLocation: sourceLocation)
            #expect(result.returnCode == .success, sourceLocation: sourceLocation)
            #expect(result.integrationId == MPKitMoEngageConstant.kitCode as NSNumber, sourceLocation: sourceLocation)
        }
    }

    @Test(.enabled(if: UIDevice.current.userInterfaceIdiom != .tv))
    func iOSValidTestConfig() async throws {
        let kit = MPKitMoEngage()
        let config = [MPKitMoEngageConstant.workspaceId: "abcde_DEBUG"]
        let stream = AsyncStream { continuation in
            var observer: Any!
            observer = NotificationCenter.default.addObserver(
                forName: .mParticleKitDidBecomeActive,
                object: nil, queue: .main
            ) { notification in
                continuation.yield(())
                NotificationCenter.default.removeObserver(observer as Any)
                continuation.finish()
            }
        }

        let result = kit.didFinishLaunching(withConfiguration: config)
        for await _ in stream { break }
        #expect(result.returnCode == .success)
        #expect(kit.started)
        #expect(kit.settings?.workspaceId == "abcde")
        #expect(kit.providerKitInstance as? MoEngage == MoEngage.sharedInstance)

        let activity = NSUserActivity(activityType: "moengage")
        activity.webpageURL = .init(string: "https://moengage.com/")
        let event = MPEvent(name: "test", type: .click)!
        let userInfo: [String: Any] = ["moengage": ["cid": "test", "app_id": "abcde"], "app_extra": [:]]
        let results = [
            kit.setDeviceToken("token".data(using: .utf8)!),
            kit.failedToRegister(forUserNotifications: NSError(domain: "error", code: 1)),
            kit.receivedUserNotification(userInfo),
            kit.handleAction(withIdentifier: "action", forRemoteNotification: userInfo),
            kit.continue(activity, restorationHandler: { _ in }),
            kit.open(activity.webpageURL!, options: [:]),
            kit.open(activity.webpageURL!, sourceApplication: "app", annotation: nil),
            kit.onSetUserAttribute(.init()),
            kit.setUserAttribute("key", value: "value"),
            kit.setUserAttribute("key", values: ["value", "value1"]),
            kit.onIdentifyComplete(.init(), request: .init()),
            kit.onLoginComplete(.init(), request: .init()),
            kit.onLogoutComplete(.init(), request: .init()),
            kit.onModifyComplete(.init(), request: .init()),
            kit.logBaseEvent(event),
            kit.setATTStatus(.denied, withATTStatusTimestampMillis: nil),
            kit.setATTStatus(.authorized, withATTStatusTimestampMillis: nil),
            kit.setOptOut(true),
            kit.setOptOut(false),
            kit.setLocation(.init(latitude: 12.9716, longitude: 77.5946))
        ]

        for (index, result) in results.enumerated() {
            let line = #line - results.count - 3 + index
            let sourceLocation = SourceLocation(
                fileID: #fileID, filePath: #fileID,
                line: line, column: #column
            )
            #expect(result.success, sourceLocation: sourceLocation)
            #expect(result.returnCode == .success, sourceLocation: sourceLocation)
            #expect(result.integrationId == MPKitMoEngageConstant.kitCode as NSNumber, sourceLocation: sourceLocation)
        }
    }

    @Test(.enabled(if: UIDevice.current.userInterfaceIdiom == .tv))
    func tvOSEmptyConfig() throws {
        let kit = MPKitMoEngage()
        let result = kit.didFinishLaunching(withConfiguration: [:])
        #expect(result.returnCode == .requirementsNotMet)
        #expect(!kit.started)
        #expect(kit.settings == nil)
        #expect(kit.providerKitInstance == nil)

        let activity = NSUserActivity(activityType: "moengage")
        activity.webpageURL = .init(string: "https://moengage.com/")
        let event = MPEvent(name: "test", type: .click)!
        let userInfo: [String: Any] = ["moengage": ["cid": "test", "app_id": "abcde"], "app_extra": [:]]
        let results = [
            kit.receivedUserNotification(userInfo),
            kit.handleAction(withIdentifier: "action", forRemoteNotification: userInfo),
            kit.continue(activity, restorationHandler: { _ in }),
            kit.open(activity.webpageURL!, options: [:]),
            kit.open(activity.webpageURL!, sourceApplication: "app", annotation: nil),
            kit.onSetUserAttribute(.init()),
            kit.setUserAttribute("key", value: "value"),
            kit.setUserAttribute("key", values: ["value", "value1"]),
            kit.onIdentifyComplete(.init(), request: .init()),
            kit.onLoginComplete(.init(), request: .init()),
            kit.onLogoutComplete(.init(), request: .init()),
            kit.onModifyComplete(.init(), request: .init()),
            kit.logBaseEvent(event),
            kit.setATTStatus(.denied, withATTStatusTimestampMillis: nil),
            kit.setATTStatus(.authorized, withATTStatusTimestampMillis: nil),
            kit.setOptOut(true),
            kit.setOptOut(false),
            kit.setLocation(.init(latitude: 12.9716, longitude: 77.5946))
        ]

        for (index, result) in results.enumerated() {
            let line = #line - results.count - 3 + index
            let sourceLocation = SourceLocation(
                fileID: #fileID, filePath: #fileID,
                line: line, column: #column
            )
            #expect(!result.success, sourceLocation: sourceLocation)
            #expect(result.returnCode == .requirementsNotMet, sourceLocation: sourceLocation)
            #expect(result.integrationId == MPKitMoEngageConstant.kitCode as NSNumber, sourceLocation: sourceLocation)
        }
    }

    @Test(.enabled(if: UIDevice.current.userInterfaceIdiom == .tv))
    func tvOSValidConfig() async throws {
        let kit = MPKitMoEngage()
        let config = [MPKitMoEngageConstant.workspaceId: "abcde"]
        let stream = AsyncStream { continuation in
            var observer: Any!
            observer = NotificationCenter.default.addObserver(
                forName: .mParticleKitDidBecomeActive,
                object: nil, queue: .main
            ) { notification in
                continuation.yield(())
                NotificationCenter.default.removeObserver(observer as Any)
                continuation.finish()
            }
        }

        let result = kit.didFinishLaunching(withConfiguration: config)
        for await _ in stream { break }
        #expect(result.returnCode == .success)
        #expect(kit.started)
        #expect(kit.settings?.workspaceId == "abcde")
        #expect(kit.providerKitInstance as? MoEngage == MoEngage.sharedInstance)

        let activity = NSUserActivity(activityType: "moengage")
        activity.webpageURL = .init(string: "https://moengage.com/")
        let event = MPEvent(name: "test", type: .click)!
        let userInfo: [String: Any] = ["moengage": ["cid": "test", "app_id": "abcde"], "app_extra": [:]]
        let results = [
            kit.receivedUserNotification(userInfo),
            kit.continue(activity, restorationHandler: { _ in }),
            kit.open(activity.webpageURL!, options: [:]),
            kit.open(activity.webpageURL!, sourceApplication: "app", annotation: nil),
            kit.onSetUserAttribute(.init()),
            kit.setUserAttribute("key", value: "value"),
            kit.setUserAttribute("key", values: ["value", "value1"]),
            kit.onIdentifyComplete(.init(), request: .init()),
            kit.onLoginComplete(.init(), request: .init()),
            kit.onLogoutComplete(.init(), request: .init()),
            kit.onModifyComplete(.init(), request: .init()),
            kit.logBaseEvent(event),
            kit.setATTStatus(.denied, withATTStatusTimestampMillis: nil),
            kit.setATTStatus(.authorized, withATTStatusTimestampMillis: nil),
            kit.setOptOut(true),
            kit.setOptOut(false),
            kit.setLocation(.init(latitude: 12.9716, longitude: 77.5946))
        ]

        for (index, result) in results.enumerated() {
            let line = #line - results.count - 3 + index
            let sourceLocation = SourceLocation(
                fileID: #fileID, filePath: #fileID,
                line: line, column: #column
            )
            #expect(result.success, sourceLocation: sourceLocation)
            #expect(result.returnCode == .success, sourceLocation: sourceLocation)
            #expect(result.integrationId == MPKitMoEngageConstant.kitCode as NSNumber, sourceLocation: sourceLocation)
        }
    }

    @Test
    func applicationOpenWithMissingURL() {
        let kit = MPKitMoEngage()
        let result = kit.continue(.init(activityType: "test"), restorationHandler: { _ in })
        #expect(result.returnCode == .requirementsNotMet)
    }

    @Test
    func commerceEvent() {
        let kit = MPKitMoEngage()
        let config = [MPKitMoEngageConstant.workspaceId: "abcde"]
        let _ = kit.didFinishLaunching(withConfiguration: config)
        let product = MPProduct(name: "Double Room - Econ Rate", sku: "econ-1", quantity: 4, price: 100.00)

        let attributes = MPTransactionAttributes()
        attributes.transactionId = "foo-transaction-id"
        attributes.revenue = 430.00
        attributes.tax = 30.00

        let event = MPCommerceEvent(action: .purchase, product: product)
        event.transactionAttributes = attributes;
        let result = kit.logBaseEvent(event)
        #expect(result.returnCode == .success)
    }

    @Test(.enabled(if: UIDevice.current.userInterfaceIdiom != .tv))
    func invalidPushPayload() throws {
        let kit = MPKitMoEngage()
        let config = [MPKitMoEngageConstant.workspaceId: "abcde"]
        let _ = kit.didFinishLaunching(withConfiguration: config)

        let userInfo: [String: Any] = ["moengage": ["app_id": "abcde"]]
        let results = [
            kit.receivedUserNotification(userInfo),
            kit.handleAction(withIdentifier: "action", forRemoteNotification: userInfo),
        ]

        for (index, result) in results.enumerated() {
            let line = #line - results.count - 3 + index
            let sourceLocation = SourceLocation(
                fileID: #fileID, filePath: #fileID,
                line: line, column: #column
            )
            #expect(!result.success, sourceLocation: sourceLocation)
            #expect(result.returnCode == .requirementsNotMet, sourceLocation: sourceLocation)
            #expect(result.integrationId == MPKitMoEngageConstant.kitCode as NSNumber, sourceLocation: sourceLocation)
        }
    }

    @Test(.enabled(if: UIDevice.current.userInterfaceIdiom != .tv))
    func nonMoEngagePushPayload() throws {
        let kit = MPKitMoEngage()
        let config = [MPKitMoEngageConstant.workspaceId: "abcde"]
        let _ = kit.didFinishLaunching(withConfiguration: config)

        let userInfo: [String: Any] = ["app_extra": [:]]
        let results = [
            kit.receivedUserNotification(userInfo),
            kit.handleAction(withIdentifier: "action", forRemoteNotification: userInfo),
        ]

        for (index, result) in results.enumerated() {
            let line = #line - results.count - 3 + index
            let sourceLocation = SourceLocation(
                fileID: #fileID, filePath: #fileID,
                line: line, column: #column
            )
            #expect(!result.success, sourceLocation: sourceLocation)
            #expect(result.returnCode == .requirementsNotMet, sourceLocation: sourceLocation)
            #expect(result.integrationId == MPKitMoEngageConstant.kitCode as NSNumber, sourceLocation: sourceLocation)
        }
    }

    @Test
    func idfaRestricted() throws {
        let kit = MPKitMoEngage()
        let config = [MPKitMoEngageConstant.workspaceId: "abcde"]
        let _ = kit.didFinishLaunching(withConfiguration: config)

        let result = kit.setATTStatus(.restricted, withATTStatusTimestampMillis: nil)
        #expect(!result.success)
        #expect(result.returnCode == .unavailable)
        #expect(result.integrationId == MPKitMoEngageConstant.kitCode as NSNumber)
    }

    @Test(.enabled(if: UIDevice.current.userInterfaceIdiom == .tv))
    func tvOSUnavailableAPIs() throws {
        let kit = MPKitMoEngage()
        let config = [MPKitMoEngageConstant.workspaceId: "abcde"]
        let _ = kit.didFinishLaunching(withConfiguration: config)

        let results = [
            kit.setDeviceToken("token".data(using: .utf8)!),
            kit.failedToRegister(forUserNotifications: NSError(domain: "error", code: 1)),
        ]

        for (index, result) in results.enumerated() {
            let line = #line - results.count - 3 + index
            let sourceLocation = SourceLocation(
                fileID: #fileID, filePath: #fileID,
                line: line, column: #column
            )
            #expect(!result.success, sourceLocation: sourceLocation)
            #expect(result.returnCode == .unavailable, sourceLocation: sourceLocation)
            #expect(result.integrationId == MPKitMoEngageConstant.kitCode as NSNumber, sourceLocation: sourceLocation)
        }
    }

    @Test
    func defaultIdentityMapping() async {
        let identities1 = await withCheckedContinuation { continuation in MoEngageConfigurator.map(identities: [:]) { identities in
                continuation.resume(returning: identities)
            }
        }
        #expect(identities1.isEmpty)

        let identities2 = await withCheckedContinuation { continuation in
            MoEngageConfigurator.map(identities: [
                MPIdentity.customerId: "customerId",
                MPIdentity.email: "email@abc.com",
                MPIdentity.mobileNumber: "1234567890"
            ]) { identities in
                continuation.resume(returning: identities)
            }
        }
        #expect(identities2 == [
            MoEngageAnalyticsConstants.UserIdentityNames.uid: "customerId",
            MoEngageAnalyticsConstants.UserIdentityNames.email: "email@abc.com",
            MoEngageAnalyticsConstants.UserIdentityNames.mobileNumber: "1234567890"
        ])

        let identities3 = await withCheckedContinuation { continuation in
            MoEngageConfigurator.map(identities: [
                MPIdentity.customerId: "customerId",
                MPIdentity.alias: "alias",
                MPIdentity.email: "email@abc.com",
                MPIdentity.mobileNumber: "1234567890"
            ]) { identities in
                continuation.resume(returning: identities)
            }
        }
        #expect(identities3 == [
            MoEngageAnalyticsConstants.UserIdentityNames.uid: "alias",
            MoEngageAnalyticsConstants.UserIdentityNames.email: "email@abc.com",
            MoEngageAnalyticsConstants.UserIdentityNames.mobileNumber: "1234567890"
        ])
    }

    @Test
    func customIdentityMapping() async {
        MoEngageConfigurator.setMapping(forIdentities: [
            MPIdentity.customerId: "cId",
            MPIdentity.alias: "al",
            MPIdentity.email: "email",
            MPIdentity.mobileNumber: "mob"
        ])

        let identities1 = await withCheckedContinuation { continuation in MoEngageConfigurator.map(identities: [:]) { identities in
                continuation.resume(returning: identities)
            }
        }
        #expect(identities1.isEmpty)

        let identities2 = await withCheckedContinuation { continuation in
            MoEngageConfigurator.map(identities: [
                MPIdentity.customerId: "customerId",
                MPIdentity.email: "email@abc.com",
                MPIdentity.mobileNumber: "1234567890"
            ]) { identities in
                continuation.resume(returning: identities)
            }
        }
        #expect(identities2 == [
            "cId": "customerId",
            "email": "email@abc.com",
            "mob": "1234567890"
        ])

        let identities3 = await withCheckedContinuation { continuation in
            MoEngageConfigurator.map(identities: [
                MPIdentity.customerId: "customerId",
                MPIdentity.alias: "alias",
                MPIdentity.email: "email@abc.com",
                MPIdentity.mobileNumber: "1234567890"
            ]) { identities in
                continuation.resume(returning: identities)
            }
        }
        #expect(identities3 == [
            "al": "alias",
            "email": "email@abc.com",
            "mob": "1234567890"
        ])
    }
}
