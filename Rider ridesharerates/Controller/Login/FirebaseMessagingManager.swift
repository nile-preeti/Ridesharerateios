//
//  FirebaseMessagingManager.swift
//  Rider ridesharerates
//
//  Created by malika on 05/04/24.
//

import Foundation
import Firebase

class FirebaseMessagingManager: NSObject {
    static let shared = FirebaseMessagingManager()
    
    private override init() {
        super.init()
        Messaging.messaging().delegate = self
    }
    
    func registerForRemoteNotifications() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
}

extension FirebaseMessagingManager: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        NSUSERDEFAULT.set(fcmToken, forKey: kFcmToken)
        print("Firebase registration token: \(fcmToken ?? "")")
        // Do something with the FCM token here, such as sending it to your server
    }
}

extension FirebaseMessagingManager: UNUserNotificationCenterDelegate {
    // Handle notifications here if needed
}
