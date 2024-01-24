//
//  MatchPhotoView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/23/24.
//

import SwiftUI
import Firebase

struct MatchPhotoView: View {
    var match: Match
    @Binding var photoURLs: [String: String]

    var body: some View {
        Group {
            if let photoURL = photoURLs[match.matchedUserEmail], let image = ImageCache.shared.getImage(forKey: photoURL) {
                Image(uiImage: image)
                    .resizable()
            } else {
                // Placeholder if the image is not available in the cache
                Rectangle()
                    .fill(Color.gray)
            }
        }
        .frame(width: 100, height: 100)
        .cornerRadius(10)
        .onAppear {
            fetchFirstPhotoURL(matchEmail: match.matchedUserEmail)
        }
    }
    private func fetchFirstPhotoURL(matchEmail: String) {
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
}

//#Preview {
//    MatchPhotoView()
//}
