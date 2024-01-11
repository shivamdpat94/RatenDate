import SwiftUI

struct MainTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isLoginSuccessful: Bool = false
    @State private var profiles: [RetrievedProfile] = []

    var body: some View {
        VStack(spacing: 0) {
            // Banner at the top
            Text("LemonLime")
                .font(Font.custom("Nunito-Black", size: 20))

//                .padding() // Add some padding at the top for spacing
//                .foregroundColor(colorScheme == .dark ? .white : .black)


            TabView {
                ProfileStackView(profiles: $profiles)
                    .tabItem {
                        tabIcon("lemon favicon-32x32")
                        Text("Profiles")
                    }
                
                RateView()
                    .tabItem {
                        tabIcon("rate favicon-32x32")
                        Text("Ratings")
                    }
                
                LikesMeView()
                    .tabItem {
                        tabIcon("hearts favicon-32x32")
                        Text("LikesMe")
                    }
                
                MatchView()
                    .tabItem {
                        tabIcon("chat favicon-32x32")
                        Text("Match")
                    }
                
                SettingsView()
                    .tabItem {
                        tabIcon("profile favicon-32x32")
                        Text("Profile")
                    }
            }
            .background(Color.white)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationTitle("")
            .onAppear {
                self.isLoginSuccessful = true
                fetchProfiles()

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

    
    private func fetchProfiles() {
        FirebaseService().fetchProfiles { fetchedProfiles in
            self.profiles = fetchedProfiles
        }
    }

    
    
    // Helper function to create tab icons
    private func tabIcon(_ imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30) // Adjusted size to a reasonable value
            .if(colorScheme == .dark) {
                $0.colorInvert() // Invert colors if in dark mode
            }
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
