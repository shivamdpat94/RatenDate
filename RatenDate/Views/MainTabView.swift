import SwiftUI
import Firebase


struct MainTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isLoginSuccessful: Bool = false
    @State private var profiles: [Profile] = []
    @State private var selectedTab: Int = 0 // Track the selected tab
    @EnvironmentObject var sessionManager: UserSessionManager

    var body: some View {
        VStack(spacing: 0) {
            // Banner at the top
            Text("LemonLime")
                .font(Font.custom("Nunito-Black", size: 20))

//                .padding() // Add some padding at the top for spacing
//                .foregroundColor(colorScheme == .dark ? .white : .black)


            TabView(selection: $selectedTab) {
                ProfileStackView(profiles: $profiles)
                    .tabItem {
                        tabIcon("lemon favicon-32x32", isSelected: selectedTab == 0)
                        Text("Profiles")
                    }
                    .tag(0)

                FindCallView()
                    .tabItem {
                        tabIcon("rate favicon-32x32", isSelected: selectedTab == 1)
                        Text("Ratings")
                    }
                    .tag(1)

                LikesMeView()
                    .tabItem {
                        tabIcon("hearts favicon-32x32", isSelected: selectedTab == 2)
                        Text("LikesMe")
                    }
                    .tag(2)

                MatchesView()
                    .tabItem {
                        tabIcon("chat favicon-32x32", isSelected: selectedTab == 3)
                        Text("Match")
                    }
                    .tag(3)

                SettingsView()
                    .tabItem {
                        tabIcon("profile favicon-32x32", isSelected: selectedTab == 4)
                        Text("Profile")
                    }
                    .tag(4)
            }
            .background(Color.white)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationTitle("")
            .onAppear {
                self.isLoginSuccessful = true
                fetchProfiles()
                preloadMatchData() // Call preloadMatchData here
                fetchAndUpdateFCMToken()

            }
        }
        .background(
            Image("lemonfinal") // Reference your image asset here
                .resizable() // Make the image resizable
                .scaledToFill() // Scale the image to fill the background
                .edgesIgnoringSafeArea(.all) // Ignore the safe area to cover the whole screen
                .opacity(0.25) // Make the image 25% transparent
                .padding(.top, 22.9)

        )
    }

    private func fetchAndUpdateFCMToken() {
        guard let email = sessionManager.email else { return }

        FCMTokenManager.fetchFCMToken { token in
            guard let token = token else { return }

            FCMTokenManager.updateUserFCMToken(email: email, token: token) {
                print("FCM token updated successfully for \(email)")
            }
        }
    }
    private func fetchProfiles() {
        FirebaseService().fetchProfiles { fetchedProfiles in
            self.profiles = fetchedProfiles
        }
    }

    
    
    // Helper function to create tab icons
    private func tabIcon(_ imageName: String, isSelected: Bool) -> some View {
        Image(isSelected ? "green \(imageName)" : imageName) // Choose the green version if selected
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .if(colorScheme == .dark) {
                $0.colorInvert()
            }
    }
    // Add this method to MainTabView
    private func preloadMatchData() {
        print("in preload matchdata")
        guard let email = sessionManager.email else { return }
        let db = Firestore.firestore()

        db.collection("profiles").document(email).getDocument { (document, error) in
            if let document = document, document.exists, let profileData = document.data(),
               let matchSet = profileData["matchSet"] as? [String] {
                print("preloadImagesforMatches")
                self.preloadImagesForMatches(matchSet: matchSet, db: db)
            } else {
                print("Document does not exist or error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    private func preloadImagesForMatches(matchSet: [String], db: Firestore) {
        for chatID in matchSet {
            // Fetch chat details
            db.collection("Chats").document(chatID).getDocument { (document, error) in
                if let document = document, document.exists,
                   let chatData = document.data(),
                   let participants = chatData["participants"] as? [String],
                   let matchedUserEmail = participants.first(where: { $0 != self.sessionManager.email }) {
                    // Fetch user profile for image URL
                    db.collection("profiles").document(matchedUserEmail).getDocument { (userDoc, userError) in
                        if let userDoc = userDoc, userDoc.exists,
                           let userData = userDoc.data(),
                           let photoURLs = userData["photoURLs"] as? [String], !photoURLs.isEmpty {
                            print("DownloadandcacheImage")
                            self.downloadAndCacheImage(from: photoURLs[0])
                        }
                    }
                }
            }
        }
    }

    private func downloadAndCacheImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    ImageCache.shared.setImage(image, forKey: urlString)
                }
            }
        }.resume()
    }


    
}

// Extension to conditionally apply modifiers
extension View {
    @ViewBuilder func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
