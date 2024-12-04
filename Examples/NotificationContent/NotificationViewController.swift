//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by Rakshitha on 05/10/21.
//  Copyright © 2021 MoEngage Inc. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import MoEngageRichNotification

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MoEngageSDKRichNotification.setAppGroupID("group.com.alphadevs.MoEngage.NotificationServices")
    }
    
    func didReceive(_ notification: UNNotification) {
        MoEngageSDKRichNotification.addPushTemplate(toController: self, withNotification: notification)
    }

}
