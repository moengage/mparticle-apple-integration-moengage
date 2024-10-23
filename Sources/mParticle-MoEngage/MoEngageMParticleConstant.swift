//
//  MoEngageMParticleConstant.swift
//
//
//  Created by Soumya Ranjan Mahunt on 04/09/24.
//

import Foundation

struct MPKitMoEngageConstant {
    static let kitCode = 1167
    static let workspaceId = "APP_ID"
    static let mParticleId = "USER_ATTRIBUTE_MPARTICLE_ID"
    static let mpDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
        return dateFormatter
    }()
}

struct MPKitMoEngageSettings: Hashable {
    let workspaceId: String
}
