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
                        MatchPhotoView(match: match, photoURLs: $photoURLs)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
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
