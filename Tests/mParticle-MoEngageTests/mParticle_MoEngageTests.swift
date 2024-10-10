//
//  mParticle_MoEngageTests.swift
//
//
//  Created by Soumya Ranjan Mahunt on 04/09/24.
//

import XCTest
import MoEngageSDK
import mParticle_Apple_SDK
@testable import mParticle_MoEngage

final class mParticle_MoEngageTests: XCTestCase {

    func testiOSEmptyConfig() throws {
        guard UIDevice.current.userInterfaceIdiom != .tv else {
            throw XCTSkip("Skipping iOS only test")
        }

        let kit = MPKitMoEngage()
        let result = kit.didFinishLaunching(withConfiguration: [:])
        XCTAssertEqual(result.returnCode, .requirementsNotMet)
        XCTAssertFalse(kit.started)
        XCTAssertNil(kit.settings)
        XCTAssertNil(kit.providerKitInstance)

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
            let line: UInt = #line - UInt(results.count) - 3 + UInt(index)
            XCTAssertFalse(result.success, line: line)
            XCTAssertEqual(result.returnCode, .requirementsNotMet, line: line)
            XCTAssertEqual(result.integrationId, MPKitMoEngageConstant.kitCode as NSNumber, line: line)
        }
    }

    func testiOSValidConfig() throws {
        guard UIDevice.current.userInterfaceIdiom != .tv else {
            throw XCTSkip("Skipping iOS only test")
        }

        let kit = MPKitMoEngage()
        let config = ["appId": "abcde"]
        let exp = XCTNSNotificationExpectation(name: .mParticleKitDidBecomeActive)
        let result = kit.didFinishLaunching(withConfiguration: config)
        XCTAssertEqual(result.returnCode, .success)
        XCTAssertTrue(kit.started)
        XCTAssertEqual(kit.settings?.workspaceId, "abcde")
        XCTAssertEqual(kit.providerKitInstance as? MoEngage, MoEngage.sharedInstance)
        wait(for: [exp], timeout: 5)

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
            let line: UInt = #line - UInt(results.count) - 3 + UInt(index)
            XCTAssertTrue(result.success, line: line)
            XCTAssertEqual(result.returnCode, .success, line: line)
            XCTAssertEqual(result.integrationId, MPKitMoEngageConstant.kitCode as NSNumber, line: line)
        }
    }

    func testtvOSEmptyConfig() throws {
        guard UIDevice.current.userInterfaceIdiom == .tv else {
            throw XCTSkip("Skipping tvOS only test")
        }

        let kit = MPKitMoEngage()
        let result = kit.didFinishLaunching(withConfiguration: [:])
        XCTAssertEqual(result.returnCode, .requirementsNotMet)
        XCTAssertFalse(kit.started)
        XCTAssertNil(kit.settings)
        XCTAssertNil(kit.providerKitInstance)

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
            let line: UInt = #line - UInt(results.count) - 3 + UInt(index)
            XCTAssertFalse(result.success, line: line)
            XCTAssertEqual(result.returnCode, .requirementsNotMet, line: line)
            XCTAssertEqual(result.integrationId, MPKitMoEngageConstant.kitCode as NSNumber, line: line)
        }
    }

    func testtvOSValidConfig() throws {
        guard UIDevice.current.userInterfaceIdiom == .tv else {
            throw XCTSkip("Skipping tvOS only test")
        }

        let kit = MPKitMoEngage()
        let config = ["appId": "abcde"]
        let exp = XCTNSNotificationExpectation(name: .mParticleKitDidBecomeActive)
        let result = kit.didFinishLaunching(withConfiguration: config)
        XCTAssertEqual(result.returnCode, .success)
        XCTAssertTrue(kit.started)
        XCTAssertEqual(kit.settings?.workspaceId, "abcde")
        XCTAssertEqual(kit.providerKitInstance as? MoEngage, MoEngage.sharedInstance)
        wait(for: [exp], timeout: 5)

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
            let line: UInt = #line - UInt(results.count) - 3 + UInt(index)
            XCTAssertTrue(result.success, line: line)
            XCTAssertEqual(result.returnCode, .success, line: line)
            XCTAssertEqual(result.integrationId, MPKitMoEngageConstant.kitCode as NSNumber, line: line)
        }
    }

    func testApplicationOpenWithMissingURL() {
        let kit = MPKitMoEngage()
        let result = kit.continue(.init(activityType: "test"), restorationHandler: { _ in })
        XCTAssertEqual(result.returnCode, .requirementsNotMet)
    }

    func testCommerceEvent() {
        let kit = MPKitMoEngage()
        let config = ["appId": "abcde"]
        let _ = kit.didFinishLaunching(withConfiguration: config)
        let product = MPProduct(name: "Double Room - Econ Rate", sku: "econ-1", quantity: 4, price: 100.00)

        let attributes = MPTransactionAttributes()
        attributes.transactionId = "foo-transaction-id"
        attributes.revenue = 430.00
        attributes.tax = 30.00

        let event = MPCommerceEvent(action: .purchase, product: product)
        event.transactionAttributes = attributes;
        let result = kit.logBaseEvent(event)
        XCTAssertEqual(result.returnCode, .unavailable)
    }

    func testInvalidPushPayload() throws {
        guard UIDevice.current.userInterfaceIdiom != .tv else {
            throw XCTSkip("Skipping iOS only test")
        }

        let kit = MPKitMoEngage()
        let config = ["appId": "abcde"]
        let _ = kit.didFinishLaunching(withConfiguration: config)

        let userInfo: [String: Any] = ["moengage": ["cid": "test", "app_id": "abcde"]]
        let results = [
            kit.receivedUserNotification(userInfo),
            kit.handleAction(withIdentifier: "action", forRemoteNotification: userInfo),
        ]

        for (index, result) in results.enumerated() {
            let line: UInt = #line - UInt(results.count) - 3 + UInt(index)
            XCTAssertFalse(result.success, line: line)
            XCTAssertEqual(result.returnCode, .requirementsNotMet, line: line)
            XCTAssertEqual(result.integrationId, MPKitMoEngageConstant.kitCode as NSNumber, line: line)
        }
    }

    func testNonMoEngagePushPayload() throws {
        guard UIDevice.current.userInterfaceIdiom != .tv else {
            throw XCTSkip("Skipping iOS only test")
        }

        let kit = MPKitMoEngage()
        let config = ["appId": "abcde"]
        let _ = kit.didFinishLaunching(withConfiguration: config)

        let userInfo: [String: Any] = ["app_extra": [:]]
        let results = [
            kit.receivedUserNotification(userInfo),
            kit.handleAction(withIdentifier: "action", forRemoteNotification: userInfo),
        ]

        for (index, result) in results.enumerated() {
            let line: UInt = #line - UInt(results.count) - 3 + UInt(index)
            XCTAssertFalse(result.success, line: line)
            XCTAssertEqual(result.returnCode, .requirementsNotMet, line: line)
            XCTAssertEqual(result.integrationId, MPKitMoEngageConstant.kitCode as NSNumber, line: line)
        }
    }

    func testIDFARestricted() throws {
        let kit = MPKitMoEngage()
        let config = ["appId": "abcde"]
        let _ = kit.didFinishLaunching(withConfiguration: config)

        let result = kit.setATTStatus(.restricted, withATTStatusTimestampMillis: nil)
        XCTAssertFalse(result.success)
        XCTAssertEqual(result.returnCode, .unavailable)
        XCTAssertEqual(result.integrationId, MPKitMoEngageConstant.kitCode as NSNumber)
    }

    func testtvOSUnavailableAPIs() throws {
        guard UIDevice.current.userInterfaceIdiom == .tv else {
            throw XCTSkip("Skipping tvOS only test")
        }

        let kit = MPKitMoEngage()
        let config = ["appId": "abcde"]
        let _ = kit.didFinishLaunching(withConfiguration: config)

        let userInfo: [String: Any] = ["moengage": ["cid": "test", "app_id": "abcde"], "app_extra": [:]]
        let results = [
            kit.setDeviceToken("token".data(using: .utf8)!),
            kit.failedToRegister(forUserNotifications: NSError(domain: "error", code: 1)),
        ]

        for (index, result) in results.enumerated() {
            let line: UInt = #line - UInt(results.count) - 3 + UInt(index)
            XCTAssertFalse(result.success, line: line)
            XCTAssertEqual(result.returnCode, .unavailable, line: line)
            XCTAssertEqual(result.integrationId, MPKitMoEngageConstant.kitCode as NSNumber, line: line)
        }
    }
}
