//
//  MoEngageMParticleConstant.swift
//
//
//  Created by Soumya Ranjan Mahunt on 04/09/24.
//

import Foundation
import mParticle_Apple_SDK

struct MPKitMoEngageConstant {
    static let kitCode = 1167
    static let workspaceId = "APP_ID"
    static let mParticleId = "USER_ATTRIBUTE_MPARTICLE_ID"
    static let eventType = "event_type"
    static let debugIdentifier = "_DEBUG"
}

struct MPKitMoEngageSettings: Hashable {
    let workspaceId: String
}

/// Internal extension for event-type to string mapping.
extension MPEventType {
    /// Stringified value for enum.
    ///
    /// Picked from `NSStringFromEventType`.
    var stringValue: String {
        switch self {
        case .navigation:
            return "Navigation"
        case .location:
            return "Location"
        case .search:
            return "Search"
        case .transaction:
            return "Transaction"
        case .userContent:
            return "UserContent"
        case .userPreference:
            return "UserPreference"
        case .social:
            return "Social"
        case .other:
            return "Other"
        case .media:
            return "Media"
        case .addToCart:
            return "ProductAddToCart"
        case .removeFromCart:
            return "ProductRemoveFromCart"
        case .checkout:
            return "ProductCheckout"
        case .checkoutOption:
            return "ProductCheckoutOption"
        case .click:
            return "ProductClick"
        case .viewDetail:
            return "ProductViewDetail"
        case .purchase:
            return "ProductPurchase"
        case .refund:
            return "ProductRefund"
        case .promotionView:
            return "PromotionView"
        case .promotionClick:
            return "PromotionClick"
        case .addToWishlist:
            return "ProductAddToWishlist"
        case .removeFromWishlist:
            return "ProductRemoveFromWishlist"
        case .impression:
            return "ProductImpression"
        default:
            return "Default"
        }
    }
}
