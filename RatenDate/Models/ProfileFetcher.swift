////
////  ProfileFetcher.swift
////  RatenDate
////
////  Created by Shivam Patel on 1/2/24.
////
//
//import Firebase
//import UIKit
//
//class ProfileFetcher: ObservableObject {
//    @Published var profiles: [Profile] = []
//    
//    init() {
//        fetchProfiles()
//    }
//    
//    func fetchProfiles() {
//        let db = Firestore.firestore()
//        db.collection("profiles").getDocuments { [weak self] (snapshot, error) in
//            if let snapshot = snapshot {
//                self?.profiles = snapshot.documents.compactMap { doc -> Profile? in
//                    let data = doc.data()
//                    let id = doc.documentID
//                    let firstName = data["firstName"] as? String ?? ""
//                    // ... other fields
//                    
//                    let profile = Profile(
//                        imageNames: [], // Add actual image names if you have them
//                        location: CLLocation(), // Replace with actual location from data
//                        age: data["age"] as? Int ?? 0,
//                        id: id,
//                        gender: data["gender"] as? String ?? "",
//                        ethnicity: data["ethnicity"] as? String ?? "",
//                        firstName: firstName,
//                        bio: data["bio"] as? String ?? "",
//                        interests: data["interests"] as? [String] ?? [],
//                        lookingFor: data["lookingFor"] as? String ?? "",
//                        rateSum: data["rateSum"] as? Double ?? 0.0,
//                        timesRated: data["timesRated"] as? Double ?? 0.0,
//                        photoURLs: data["photoURLs"] as? [String] ?? []
//                    )
//                    self?.fetchImages(for: profile)
//                    return profile
//                }
//            } else if let error = error {
//                print("Error fetching profiles: \(error)")
//            }
//        }
//    }
//    
//    private func fetchImages(for profile: Profile) {
//        let storage = Storage.storage()
//        profile.photoURLs.forEach { url in
//            let reference = storage.reference(forURL: url)
//            reference.getData(maxSize: 1 * 1024 * 1024) { [weak self] data, error in
//                if let data = data, let image = UIImage(data: data) {
//                    if let index = self?.profiles.firstIndex(where: { $0.id == profile.id }) {
//                        self?.profiles[index].images.append(image)
//                    }
//                } else if let error = error {
//                    print("Error fetching image: \(error)")
//                }
//            }
//        }
//    }
//}
