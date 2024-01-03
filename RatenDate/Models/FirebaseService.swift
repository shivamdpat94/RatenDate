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
}
