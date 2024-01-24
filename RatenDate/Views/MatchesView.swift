import SwiftUI
import FirebaseFirestore

struct MatchesView: View {
    @State private var selectedMatchName: String = ""
    @State private var selectedChatID: String = ""
    @State private var isChatViewActive: Bool = false
    @State private var topMatches: [Match] = []
    @State private var chattedMatches: [Match] = []
    @EnvironmentObject var sessionManager: UserSessionManager
    @State private var allPhotoURLs: [String: String] = [:]

    var body: some View {
        NavigationView {
            VStack {
                TopMatchesView(matches: topMatches, photoURLs: $allPhotoURLs)
                    .frame(height: 120)

                Divider()
                List {
                    ForEach(chattedMatches) { match in
                        createMatchNavigationLink(match: match)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("LEMONLIME")
        }
        .onAppear(perform: fetchMatchData)
        .onDisappear {
            // Reset selectedChatID when leaving the view
            self.selectedChatID = ""
        }
    }

    private func createMatchNavigationLink(match: Match) -> some View {
        NavigationLink(
            destination: ChatView(match: match),
            isActive: Binding(
                get: { self.selectedChatID == match.id },
                set: { _ in }
            )
        ) {
            ChatPreviewView(match: match, photoURLs: $allPhotoURLs )
                .onTapGesture {
                    self.selectedChatID = match.id
                    // You can also update any other state here as needed
                }
        }
    }




    private func fetchMatchData() {
        guard let email = sessionManager.email else { return }
        let db = Firestore.firestore()

        topMatches.removeAll()
        chattedMatches.removeAll()

        db.collection("profiles").document(email).getDocument { (document, error) in
            if let document = document, document.exists {
                let profileData = document.data() ?? [:]
                if let matchSet = profileData["matchSet"] as? [String] {
                    self.processMatches(matchSet: matchSet, db: db)
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    private func processMatches(matchSet: [String], db: Firestore) {
        for chatID in matchSet {
            db.collection("Chats").document(chatID).collection("Messages").getDocuments { (snapshot, error) in
                let hasMessages = snapshot != nil && !snapshot!.documents.isEmpty
                self.createMatch(chatID: chatID, hasMessages: hasMessages) { match in
                    DispatchQueue.main.async {
                        if hasMessages {
                            self.chattedMatches.append(match)
                        } else {
                            self.topMatches.append(match)
                        }
                    }
                }
            }
        }
    }

    private func createMatch(chatID: String, hasMessages: Bool, completion: @escaping (Match) -> Void) {
        let db = Firestore.firestore()

        db.collection("Chats").document(chatID).getDocument { (document, error) in
            if let document = document, document.exists {
                let chatData = document.data() ?? [:]
                if let participants = chatData["participants"] as? [String], let matchedUserEmail = participants.first(where: { $0 != self.sessionManager.email }) {
                    print("Participants are ", participants)
                    print("MatchedUserEmail is ", matchedUserEmail)
                    let match = Match(
                        id: chatID,
                        name: "Name for \(chatID)", // Fetch or determine the match's name
                        image: "1024x1024", // Determine how to fetch the image
                        lastMessage: hasMessages ? "Last message here" : "No messages yet",
                        messageDate: Date(),
                        matchedUserEmail: matchedUserEmail
                    )
                    completion(match)
                }
            } else {
                print("Document does not exist or error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

}

// Assuming Match is a struct representing a match
struct Match: Identifiable {
    var id: String
    var name: String
    var image: String
    var lastMessage: String
    var messageDate: Date
    var matchedUserEmail: String  // New field to store the email of the matched user
}


struct MatchesView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView().environmentObject(UserSessionManager())
    }
}
