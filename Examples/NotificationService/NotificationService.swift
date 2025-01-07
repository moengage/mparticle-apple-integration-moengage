//
//  NotificationService.swift
//  NotificationService
//
//  Created by Rakshitha on 05/10/21.
//  Copyright © 2021 MoEngage Inc. All rights reserved.
//

import UserNotifications
import MoEngageRichNotification
import MoEngageMessaging

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        MoEngageSDKRichNotification.setAppGroupID("group.com.alphadevs.MoEngage.NotificationServices")
        
        /// If moengage must handle the ui
        MoEngageSDKRichNotification.handle(richNotificationRequest: request, withContentHandler: contentHandler)
      
        /// if you want to track only impresssion , then call below
//        MoEngageSDKMessaging.sharedInstance.logNotificationReceived(withPayload: request.content.userInfo)
//        contentHandler(bestAttemptContent!)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
