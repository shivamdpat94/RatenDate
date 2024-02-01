//
//  LikesMeViewModel.swift
//  RatenDate
//
//  Created by Mitchell Buff on 1/31/24.
//

import Firebase
import FirebaseFirestore
import SwiftUI

struct UserProfile {
    let email: String
    let firstName: String
    let photoURL: String? // Assuming you just want the first photo
}

class ProfileService {
    func fetchLikedProfiles(currentUserEmail: String, completion: @escaping ([UserProfile]) -> Void) {
        let db = Firestore.firestore()

        // Fetch the likeMeSet for the current user
        db.collection("profiles").document(currentUserEmail).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let likeMeSet = document.data()?["likeMeSet"] as? [String] else { return }

                // Fetch profiles for each email in likeMeSet
                var userProfiles = [UserProfile]()
                for email in likeMeSet {
                    db.collection("profiles").document(email).getDocument { (userDoc, err) in
                        if let userDoc = userDoc, userDoc.exists {
                            let firstName = userDoc.data()?["firstName"] as? String ?? ""
                            let photoURLs = userDoc.data()?["photoURLs"] as? [String] ?? []
                            let firstPhotoURL = photoURLs[0] // Assuming the first photo is at key "0"

                            let userProfile = UserProfile(email: email, firstName: firstName, photoURL: firstPhotoURL)
                            userProfiles.append(userProfile)

                            if userProfiles.count == likeMeSet.count {
                                // Once all profiles are fetched, return them
                                completion(userProfiles)
                            }
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}

class LikesMeViewModel: ObservableObject {
    @EnvironmentObject var sessionManager: UserSessionManager
    @Published var userProfiles: [UserProfile] = []
    private let profileService = ProfileService()

    init() {
        // Assuming you have a way to get the current user's email
        let currentUserEmail = "1@1.com"
        fetchLikedUsers(currentUserEmail: currentUserEmail)
    }

    func fetchLikedUsers(currentUserEmail: String) {
        profileService.fetchLikedProfiles(currentUserEmail: currentUserEmail) { profiles in
            DispatchQueue.main.async {
                self.userProfiles = profiles
                for prof in profiles{
                    print(prof.email, prof.firstName, prof.photoURL, "HERE IT IS")
                }
            }
        }
    }
}

