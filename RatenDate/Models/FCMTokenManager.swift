//
//  FCMTokenManager.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/24/24.
//

import Foundation
import Firebase
import FirebaseMessaging


class FCMTokenManager {
    static func fetchFCMToken(completion: @escaping (String?) -> Void) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
                completion(nil)
            } else if let token = token {
                print("FCM registration token: \(token)")
                completion(token)
            }
        }
    }

    static func updateUserFCMToken(email: String, token: String, completion: @escaping () -> Void = {}) {
        // Reference to the 'profiles' collection
        let profilesRef = Firestore.firestore().collection("profiles")
        // Document reference for the user's profile, named by their email
        let profileDoc = profilesRef.document(email)

        // Update the document with the new FCM token
        profileDoc.setData(["fcmToken": token], merge: true) { error in
            if let error = error {
                print("Error updating FCM token in the user profile: \(error)")
            } else {
                print("FCM token updated successfully in the user profile")
            }
            completion()  // Call the completion handler
        }
    }
}
