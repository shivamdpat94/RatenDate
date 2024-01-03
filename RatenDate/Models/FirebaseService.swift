//
//  FirebaseService.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/3/24.
//

import Firebase

class FirebaseService {
    let db = Firestore.firestore()

    func fetchProfiles(completion: @escaping ([RetrievedProfile]) -> Void) {
        db.collection("profiles").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var profiles = [RetrievedProfile]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    // Create a RetrievedProfile from data and append to profiles
                    let profile = RetrievedProfile(dictionary: data)
                    profiles.append(profile)
                }
                completion(profiles)
            }
        }
    }
    
    
    func saveProfileToFirebase(profile: Profile, completion: @escaping () -> Void) {
        let db = Firestore.firestore()

        db.collection("profiles").document(profile.id).setData(profile.dictionary) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Profile successfully added!")
                completion()  // Call the completion handler after the profile is successfully added
            }
        }
    }
}
