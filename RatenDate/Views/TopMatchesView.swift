import SwiftUI
import Firebase

struct TopMatchesView: View {
    var matches: [Match]
    @Binding var photoURLs: [String: String]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(matches) { match in
                    NavigationLink(destination: ChatView(match: match)) {
                        if let photoURL = photoURLs[match.matchedUserEmail] {
                            MatchPhotoView(match: match, photoURLs: $photoURLs)
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                        } else {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
struct MatchPhotoView: View {
    var match: Match
    @Binding var photoURLs: [String: String]

    var body: some View {
        Group {
            if let photoURL = photoURLs[match.matchedUserEmail], let image = ImageCache.shared.getImage(forKey: photoURL) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            } else {
                // Placeholder if the image is not available in the cache
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            }
        }
        .onAppear {
            fetchFirstPhotoURL(matchEmail: match.matchedUserEmail)
        }
    }

    private func fetchFirstPhotoURL(matchEmail: String) {
        print("matchEmail is ", matchEmail)
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




struct TopMatchesView_Previews: PreviewProvider {
    static var previews: some View {
        // Create dummy data for preview
        let dummyMatches = [
            Match(id: "1", name: "Alex", image: "image1", lastMessage: "Hey!", messageDate: Date(), matchedUserEmail: "Alex@gmail.com"),
            Match(id: "2", name: "Sam", image: "image2", lastMessage: "Hi there", messageDate: Date(), matchedUserEmail: "Sam@gmail.com")
        ]

        // Create a dummy photoURLs dictionary
        let dummyPhotoURLs = [
            "Alex@gmail.com": "https://example.com/photo1.jpg",
            "Sam@gmail.com": "https://example.com/photo2.jpg"
        ]

        // Provide the photoURLs dictionary as a constant binding
        TopMatchesView(matches: dummyMatches, photoURLs: .constant(dummyPhotoURLs))
    }
}
