//
//  MoEngageConfigurator.swift
//
//
//  Created by Soumya Ranjan Mahunt on 04/09/24.
//

import Foundation
import MoEngageSDK
import mParticle_Apple_SDK

/// This class is used for initializing the MoEngageSDK
@objc
public final class MoEngageConfigurator: NSObject {
    /// Method to initialize the default instance of MoEngageSDK
    /// with data from Info.plist.
    @objc public static func configureDefaultInstance() {
        MoEngage.sharedInstance.initializeDefaultInstance()

        guard
            let sdkConfig = try? MoEngageInitialization.fetchSDKConfigurationFromInfoPlist(),
            !sdkConfig.appId.isEmpty
        else {
            MoEngageLogger.logDefault(message: "App ID is empty. Please provide a valid App ID to setup the SDK.")
            return
        }
        trackPluginTypeAndVersion(sdkConfig: sdkConfig)
    }

    /// Method to initialize the default instance of MoEngageSDK
    /// - Parameter sdkConfig: MoEngageSDKConfig
    @objc public static func configureDefaultInstance(sdkConfig: MoEngageSDKConfig) {
        updateSDKConfig(sdkConfig: sdkConfig)
#if DEBUG
        MoEngage.sharedInstance.initializeDefaultTestInstance(sdkConfig)
#else
        MoEngage.sharedInstance.initializeDefaultLiveInstance(sdkConfig)
#endif
        trackPluginTypeAndVersion(sdkConfig: sdkConfig)
    }

    /// Method to initialize the other instance of MoEngageSDK
    /// - Parameter sdkConfig: MoEngageSDKConfig
    @objc public static func configureInstance(sdkConfig: MoEngageSDKConfig) {
        updateSDKConfig(sdkConfig: sdkConfig)
#if DEBUG
        MoEngage.sharedInstance.initializeTestInstance(sdkConfig)
#else
        MoEngage.sharedInstance.initializeLiveInstance(sdkConfig)
#endif
        trackPluginTypeAndVersion(sdkConfig: sdkConfig)
    }

    /// Method to initialize the default instance of MoEngageSDK
    /// - Parameter sdkConfig: MoEngageSDKConfig
    /// - Parameter test: Whether to initialize test instance of SDK.
    @objc public static func configureDefaultInstance(sdkConfig: MoEngageSDKConfig, test: Bool) {
        updateSDKConfig(sdkConfig: sdkConfig)
        if test {
            MoEngage.sharedInstance.initializeDefaultTestInstance(sdkConfig)
        } else {
            MoEngage.sharedInstance.initializeDefaultLiveInstance(sdkConfig)
        }
        trackPluginTypeAndVersion(sdkConfig: sdkConfig)
    }

    /// Method to initialize the other instance of MoEngageSDK
    /// - Parameter sdkConfig: MoEngageSDKConfig
    /// - Parameter test: Whether to initialize test instance of SDK.
    @objc public static func configureInstance(sdkConfig: MoEngageSDKConfig, test: Bool) {
        updateSDKConfig(sdkConfig: sdkConfig)
        if test {
            MoEngage.sharedInstance.initializeTestInstance(sdkConfig)
        } else {
            MoEngage.sharedInstance.initializeLiveInstance(sdkConfig)
        }
        trackPluginTypeAndVersion(sdkConfig: sdkConfig)
    }

    private static func updateSDKConfig(sdkConfig: MoEngageSDKConfig) {
        sdkConfig.setPartnerIntegrationType(integrationType: .mParticleNative)
    }

    private static func trackPluginTypeAndVersion(sdkConfig: MoEngageSDKConfig) {
        let integrationInfo = MoEngageIntegrationInfo(pluginType: .mParticleNative, version: MPKitMoEngageConstant.moduleVersion)
        MoEngageCoreIntegrator.sharedInstance.addIntergrationInfo(info: integrationInfo, appId: sdkConfig.appId)
    }
}

extension MoEngageConfigurator {
    private static let defaultIdentitiesMap: [MPIdentity: String] = [
        MPIdentity.alias: MoEngageAnalyticsConstants.UserIdentityNames.uid,
        MPIdentity.customerId: MoEngageAnalyticsConstants.UserIdentityNames.uid,
        MPIdentity.email: MoEngageAnalyticsConstants.UserIdentityNames.email,
        MPIdentity.mobileNumber: MoEngageAnalyticsConstants.UserIdentityNames.mobileNumber
    ]

    private static var identitiesMap = defaultIdentitiesMap

    /// Set mParticle identities equivalent MoEngage identities.
    ///
    /// Set the mapping before initializing mParticle.
    /// - Parameter mapping: The mapping to set.
    public static func setMapping(forIdentities mapping: [MPIdentity: String]) {
        MoEngageCoreHandler.globalQueue.async {
            Self.identitiesMap = Self.defaultIdentitiesMap.merging(mapping) { $1 }
        }
    }

    /// Get mParticle identities equivalent MoEngage identities.
    /// - Parameters:
    ///   - identities: The mParticle identities.
    ///   - completion: The block accepting equivalent MoEngage identities.
    static func map(identities: [MPIdentity: String], completion: @escaping ([String: String]) -> Void) {
        MoEngageCoreHandler.globalQueue.async {
            var identities = identities
            if identities[MPIdentity.alias] != nil {
                // If alias is present, it should be used as the primary identifier.
                identities.removeValue(forKey: MPIdentity.customerId)
            }

            completion(
                identities.reduce(into: [:]) { partialResult, item in
                    guard let moEngageId = Self.identitiesMap[item.key] else { return }
                    partialResult[moEngageId] = item.value
                }
            )
        }
    }
}
