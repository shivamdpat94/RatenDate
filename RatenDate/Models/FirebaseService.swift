//
//  FirebaseService.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/3/24.
//

import Firebase

class FirebaseService {
    let db = Firestore.firestore()

    func fetchProfiles(completion: @escaping ([Profile]) -> Void) {
        db.collection("profiles").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var profiles = [Profile]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let profile = Profile(dictionary: data)
                    profiles.append(profile)
                }
                completion(profiles)
            }
        }
    }
    
    
    func saveProfileToFirebase(profile: Profile, completion: @escaping () -> Void) {
        let db = Firestore.firestore()

        db.collection("profiles").document(profile.email).setData(profile.dictionary) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Profile successfully added!")
                completion()  // Call the completion handler after the profile is successfully added
            }
        }
    }
    
    
    
    func fetchProfile(email: String, completion: @escaping (Profile?) -> Void) {
        db.collection("profiles").document(email).getDocument { (document, error) in
            if let document = document, document.exists {
                let profileData = document.data() ?? [:]
                let profile = Profile(dictionary: profileData)
                completion(profile)
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }

    
    
    
    func updateProfile(profile: Profile, completion: @escaping (Bool) -> Void) {
        db.collection("profiles").document(profile.email).updateData(profile.dictionary) { error in
            if let error = error {
                print("Error updating profile: \(error)")
                completion(false)
            } else {
                print("Profile successfully updated!")
                completion(true)
            }
        }
    }

}



