//
//  mParticle_MoEngage.swift
//
//
//  Created by Soumya Ranjan Mahunt on 04/09/24.
//

import Foundation
import CoreLocation
import MoEngageSDK
import mParticle_Apple_SDK

@objc(MPKitMoEngage)
public final class MPKitMoEngage: NSObject, MPKitProtocol {
    public private(set) var started: Bool = false
    public var configuration: [AnyHashable: Any] = [:]
    internal private(set) var settings: MPKitMoEngageSettings?

    public func didFinishLaunching(withConfiguration configuration: [AnyHashable: Any]) -> MPKitExecStatus {
        guard var workspaceId = configuration[MPKitMoEngageConstant.workspaceId] as? String else {
            MoEngageLogger.logDefault(logLevel: .fatal, message: "App ID not present in mParticle settings")
            return execStatus(.requirementsNotMet)
        }

        // Remove debug suffix
        let debugIdentifier = MPKitMoEngageConstant.debugIdentifier
        if workspaceId.hasSuffix(debugIdentifier) {
            workspaceId = String(workspaceId.dropLast(debugIdentifier.count))
        }

        self.configuration = configuration
        self.settings = .init(workspaceId: workspaceId)
        start()
        return execStatus(.success)
    }

    public var providerKitInstance: Any? {
        return started && settings != nil ? MoEngage.sharedInstance : nil
    }

    public static func kitCode() -> NSNumber { MPKitMoEngageConstant.kitCode as NSNumber }

    func execStatus(_ returnCode: MPKitReturnCode) -> MPKitExecStatus {
        return .init(sdkCode: Self.kitCode(), returnCode: returnCode)
    }
}

// MARK: Kit Lifecycle
extension MPKitMoEngage {

    public func start() {
        guard let settings = settings else { return }
        MoEngageCoreIntegrator.sharedInstance.enableSDKForPartner(workspaceId: settings.workspaceId, integrationType: .mParticleNative)
        self.started = true

        DispatchQueue.main.async {
            let userInfo = [mParticleKitInstanceKey: Self.kitCode]
            NotificationCenter.default.post(name: .mParticleKitDidBecomeActive, object: nil, userInfo: userInfo)
        }
    }
}

// MARK: Push Registration
extension MPKitMoEngage {

    public func setDeviceToken(_ deviceToken: Data) -> MPKitExecStatus {
#if !os(tvOS)
        guard settings != nil else { return execStatus(.requirementsNotMet) }
        MoEngageSDKMessaging.sharedInstance.setPushToken(deviceToken)
        return execStatus(.success)
#else
        return execStatus(.unavailable)
#endif
    }

    public func failedToRegister(
        forUserNotifications error: (any Error)?
    ) -> MPKitExecStatus {
#if !os(tvOS)
        guard settings != nil else { return execStatus(.requirementsNotMet) }
        MoEngageSDKMessaging.sharedInstance.didFailToRegisterForPush()
        return execStatus(.success)
#else
        return execStatus(.unavailable)
#endif
    }
}

// MARK: Push Callback
extension MPKitMoEngage {

    public func receivedUserNotification(
        _ userInfo: [AnyHashable: Any]
    ) -> MPKitExecStatus {
        guard settings != nil else { return execStatus(.requirementsNotMet) }
        do {
            try MoEngageMessagingIntegrator.receivedUserNotification(payload: userInfo)
            return execStatus(.success)
        } catch {
            return execStatus(.requirementsNotMet)
        }
    }

    @available(iOSApplicationExtension, unavailable)
    public func handleAction(
        withIdentifier identifier: String,
        forRemoteNotification userInfo: [AnyHashable : Any]
    ) -> MPKitExecStatus {
        guard settings != nil else { return execStatus(.requirementsNotMet) }
        do {
            let result = try MoEngageMessagingIntegrator.handleAction(withIdentifier: identifier, forRemoteNotification: userInfo)
            return result ? execStatus(.success) : execStatus(.requirementsNotMet)
        } catch {
            return execStatus(.requirementsNotMet)
        }
    }

    // MARK: User Notifications
    @available(iOSApplicationExtension, unavailable)
    @available(tvOS, unavailable)
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter, willPresent notification: UNNotification
    ) -> MPKitExecStatus {
        guard settings != nil else { return execStatus(.requirementsNotMet) }
        MoEngageSDKMessaging.sharedInstance.userNotificationCenter(center, willPresent: notification)
        return execStatus(.success)
    }

    @available(iOSApplicationExtension, unavailable)
    @available(tvOS, unavailable)
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse
    ) -> MPKitExecStatus {
        guard settings != nil else { return execStatus(.requirementsNotMet) }
        MoEngageSDKMessaging.sharedInstance.userNotificationCenter(center, didReceive: response)
        return execStatus(.success)
    }
}

// MARK: Application Lifecycle
extension MPKitMoEngage {

    public func `continue`(
        _ userActivity: NSUserActivity,
        restorationHandler: @escaping ([Any]?) -> Void
    ) -> MPKitExecStatus {
        guard
            settings != nil, let incomingURL = userActivity.webpageURL
        else { return execStatus(.requirementsNotMet) }
        MoEngageSDKAnalytics.sharedInstance.processURL(incomingURL)
        return execStatus(.success)
    }

    public func open(
        _ url: URL, options: [String: Any]? = nil
    ) -> MPKitExecStatus {
        guard settings != nil else { return execStatus(.requirementsNotMet) }
        MoEngageSDKAnalytics.sharedInstance.processURL(url)
        return execStatus(.success)
    }

    public func open(
        _ url: URL, sourceApplication: String?, annotation: Any?
    ) -> MPKitExecStatus {
        guard settings != nil else { return execStatus(.requirementsNotMet) }
        MoEngageSDKAnalytics.sharedInstance.processURL(url)
        return execStatus(.success)
    }
}

// MARK: User attributes and identities
extension MPKitMoEngage {

    public func onSetUserAttribute(_ user: FilteredMParticleUser) -> MPKitExecStatus {
        guard settings != nil else { return execStatus(.requirementsNotMet) }
        for (key, value) in user.userAttributes {
            let result = self.setUserAttribute(key, value: value)
            if !result.success {
                return result
            }
        }
        return execStatus(.success)
    }

    public func setUserAttribute(_ key: String, value: Any) -> MPKitExecStatus {
        guard let workspaceId = settings?.workspaceId else { return execStatus(.requirementsNotMet) }
        switch key {
        case mParticleUserAttributeMobileNumber, "$MPUserMobile":
            guard let value = value as? String else { break }
            MoEngageSDKAnalytics.sharedInstance.setMobileNumber(value, forAppID: workspaceId)
            return execStatus(.success)
        case mParticleUserAttributeGender:
            let gender: MoEngageUserGender
            switch value as? String {
            case mParticleGenderMale:
                gender = .male
            case mParticleGenderFemale:
                gender = .female
            default:
                gender = .others
            }
            MoEngageSDKAnalytics.sharedInstance.setGender(gender, forAppID: workspaceId)
            return execStatus(.success)
        case mParticleUserAttributeFirstName:
            guard let value = value as? String else { break }
            MoEngageSDKAnalytics.sharedInstance.setFirstName(value, forAppID: workspaceId)
            return execStatus(.success)
        case mParticleUserAttributeLastName:
            guard let value = value as? String else { break }
            MoEngageSDKAnalytics.sharedInstance.setLastName(value, forAppID: workspaceId)
            return execStatus(.success)
        default:
            break
        }

        var key = key
        var value = value
        // All the mParticle standard attribute starts with "$".
        // Removing the "$" from attribute as it's not required in MoEngage
        if key.first == "$" {
            key.removeFirst()
        }
        // Check for boolean value that mPartcle SDK has converted to NSNumber
        if value is NSNumber, let number = value as? NSNumber, String(cString: number.objCType) == String(cString: (true as NSNumber).objCType) {
            value = number.boolValue
        }
        MoEngageSDKAnalytics.sharedInstance.setUserAttribute(value, withAttributeName: key, forAppID: workspaceId)
        return execStatus(.success)
    }

    public func setUserAttribute(_ key: String, values: [Any]) -> MPKitExecStatus {
        return self.setUserAttribute(key, value: values)
    }

    public func onIdentifyComplete(
        _ user: FilteredMParticleUser, request: FilteredMPIdentityApiRequest
    ) -> MPKitExecStatus {
        return updateUser(user, request: request, modified: false)
    }

    public func onLoginComplete(
        _ user: FilteredMParticleUser, request: FilteredMPIdentityApiRequest
    ) -> MPKitExecStatus {
        return updateUser(user, request: request, modified: false)
    }

    public func onLogoutComplete(
        _ user: FilteredMParticleUser, request: FilteredMPIdentityApiRequest
    ) -> MPKitExecStatus {
        guard let settings = settings else { return execStatus(.requirementsNotMet) }
        MoEngageSDKAnalytics.sharedInstance.resetUser(forAppID: settings.workspaceId)
        return updateUser(user, request: request, modified: false)
    }

    public func onModifyComplete(
        _ user: FilteredMParticleUser, request: FilteredMPIdentityApiRequest
    ) -> MPKitExecStatus {
        return updateUser(user, request: request, modified: true)
    }

    private func updateUser(
        _ user: FilteredMParticleUser, request: FilteredMPIdentityApiRequest, modified: Bool
    ) -> MPKitExecStatus {
        guard let settings = settings else { return execStatus(.requirementsNotMet) }

        // set identities
        if !user.userIdentities.isEmpty {
            let identities: [(MPIdentity, String)] = user.userIdentities
                .compactMap { key, value in
                    guard
                        let mParticleIdKey = MPIdentity(rawValue: key.uintValue)
                    else { return nil }
                    return (mParticleIdKey, value)
                }
            MoEngageConfigurator.map(
                identities: Dictionary(identities) { $1 }
            ) { identities in
                MoEngageSDKAnalytics.sharedInstance.identifyUser(
                    identities: identities, workspaceId: settings.workspaceId
                )
            }
        }

        // set attributes
        if let email = request.email {
            MoEngageSDKAnalytics.sharedInstance.setEmailID(email, forAppID: settings.workspaceId)
        }

        if let mobile = request.userIdentities?[MPIdentity.mobileNumber.rawValue as NSNumber] {
            MoEngageSDKAnalytics.sharedInstance.setMobileNumber(mobile, forAppID: settings.workspaceId)
        }

        MoEngageSDKAnalytics.sharedInstance.setUserAttribute("\(user.userId)", withAttributeName: MPKitMoEngageConstant.mParticleId, forAppID: settings.workspaceId)
        return execStatus(.success)
    }
}

// MARK: Events
extension MPKitMoEngage {

    public func logBaseEvent(_ event: MPBaseEvent) -> MPKitExecStatus {
        guard settings != nil else { return execStatus(.requirementsNotMet) }
        switch event {
        case let event as MPEvent:
            return logEvent(event)
        case let event as MPCommerceEvent:
            return logCommerceEvent(event)
        default:
            return execStatus(.cannotExecute)
        }
    }

    public func logEvent(_ event: MPEvent) -> MPKitExecStatus {
        guard let settings = settings else { return execStatus(.requirementsNotMet) }

        let attributes = [
            MPKitMoEngageConstant.eventType: event.type.stringValue
        ].merging(event.customAttributes ?? [:], uniquingKeysWith: { $1 })
        let properties = MoEngageProperties(withAttributes: attributes)
        if !event.shouldBeginSession {
            properties.setNonInteractive()
        }
        MoEngageSDKAnalytics.sharedInstance.trackEvent(
            event.name, withProperties: properties,
            forAppID: settings.workspaceId
        )
        return execStatus(.success)
    }

    public func logCommerceEvent(
        _ commerceEvent: MPCommerceEvent
    ) -> MPKitExecStatus {
        guard settings != nil else { return execStatus(.requirementsNotMet) }

        let status = MPKitExecStatus(
            sdkCode: Self.kitCode(), returnCode: .success, forwardCount: 0
        )
        for instruction in commerceEvent.expandedInstructions() {
            _ = logEvent(instruction.event)
            status.incrementForwardCount()
        }
        return status
    }

    public func setATTStatus(
        _ status: MPATTAuthorizationStatus,
        withATTStatusTimestampMillis attStatusTimestampMillis: NSNumber?
    ) -> MPKitExecStatus {
        guard let settings = settings else { return execStatus(.requirementsNotMet) }
        switch status {
        case .authorized:
            MoEngageSDKAnalytics.sharedInstance.enableIDFATracking(forAppID: settings.workspaceId)
        case .denied:
            MoEngageSDKAnalytics.sharedInstance.disableIDFATracking(forAppID: settings.workspaceId)
        case .restricted:
            return execStatus(.unavailable)
        default:
            break
        }
        return execStatus(.success)
    }
}

// MARK: Assorted
extension MPKitMoEngage {

    public func setOptOut(_ optOut: Bool) -> MPKitExecStatus {
        guard let settings = settings else { return execStatus(.requirementsNotMet) }
        if optOut {
            MoEngageSDKAnalytics.sharedInstance.disableDataTracking(forAppID: settings.workspaceId)
        } else {
            MoEngageSDKAnalytics.sharedInstance.enableDataTracking(forAppID: settings.workspaceId)
        }
        return execStatus(.success)
    }
}

// MARK: Location tracking
extension MPKitMoEngage {

    public func setLocation(_ location: CLLocation) -> MPKitExecStatus {
        guard let settings = settings else { return execStatus(.requirementsNotMet) }
        MoEngageSDKAnalytics.sharedInstance.setLocation(.init(withLatitude: location.coordinate.latitude, andLongitude: location.coordinate.longitude), forAppID: settings.workspaceId)
        return execStatus(.success)
    }
}
