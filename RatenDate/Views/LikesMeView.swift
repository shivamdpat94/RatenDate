//
//  LikesMeView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/8/24.
//

import SwiftUI
import Firebase

public struct LikesMeView: View {
    // This view displays all the people who have liked the user
    
    @State private var likedUsers: [Profile] = []
    @State private var photoURLs: [String:String] = [:]
    
    func fetchProfiles() {
        fetchProfilesForLikes { fetchedProfiles in
            likedUsers = fetchedProfiles
        }
    }
    
    func fetchFirstPhotoURL(matchEmail: String) {
        print("fetchFirstPhotoURL called for \(matchEmail)")
        guard !matchEmail.isEmpty else { return }

        let db = Firestore.firestore()
        db.collection("profiles").document(matchEmail).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                if let photoURLs = data["photoURLs"] as? [String], !photoURLs.isEmpty {
                    DispatchQueue.main.async {
                        self.photoURLs[matchEmail] = photoURLs[0]
                    }
                }
            }
        }
    }
    
    func fetchProfilesForLikes(completion: @escaping ([Profile]) -> Void) {
        let db = Firestore.firestore()
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
    
    func downloadAndCacheImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    ImageCache.shared.setImage(image, forKey: urlString)
                }
            }
        }.resume()
    }
    
//    if let photoURL = photoURLs[match.matchedUserEmail], let image = ImageCache.shared.getImage(forKey: photoURL) {
//        Image(uiImage: image)
//            .resizable()
//    } else {
//        // Placeholder if the image is not available in the cache
//        Rectangle()
//            .fill(Color.gray)
//    }
    
    
    
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)], spacing: 20) {
                ForEach(likedUsers, id: \.id) { user in
                    NavigationLink(destination: ProfileStackView(profiles: $likedUsers)) {
//                        MatchPhotoView(match: match, photoURLs: $photoURLs)
//                            .frame(width: 100, height: 100)
//                            .cornerRadius(10)
                        
                        if let photoURL = photoURLs[user.email], let image = ImageCache.shared.getImage(forKey: photoURL) {
                            Image(uiImage: image)
                                .resizable()
                        } else {
                            // Placeholder if the image is not available in the cache
                            Rectangle()
                                .fill(Color.gray)
                        }
                    }
                }
            }
            .padding(20)
        }
        .navigationBarTitle("Liked by Others")
        onAppear{
            fetchProfiles()
            for prof in likedUsers{
                self.downloadAndCacheImage(from: prof.photoURLs[0])
            }
            
        }
        
    }
    
}
//
//#Preview {
//    LikesMeView(likedUsers: [Profile])
//}
