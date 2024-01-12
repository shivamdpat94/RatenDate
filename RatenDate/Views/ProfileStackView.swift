import SwiftUI

struct ProfileStackView: View {
    @Binding var profiles: [RetrievedProfile]
    @State private var currentIndex: Int = 0
    @EnvironmentObject var sessionManager: UserSessionManager



    var body: some View {
        ZStack {
            Image("lemonfinal")
                .resizable()
                .scaledToFill()
                .opacity(0.25)
                .edgesIgnoringSafeArea(.all)

            VStack {
                if !filteredProfiles.isEmpty {
                    ProfileView(profile: filteredProfiles[currentIndex])
                        .transition(.slide)

                    Button(action: {
                        withAnimation {
                            removeCurrentProfile()
                        }
                    }) {
                        Text("Next Profile")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                } else {
                    Text("No profiles available.")
                    Button(action: fetchProfilesAgain) {
                        Text("Fetch Profiles Again")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.bottom, 100)
        }
        .onAppear {
            fetchProfilesIfNeeded()
        }
    }
    
    
    private func fetchProfilesIfNeeded() {
         if profiles.isEmpty {
             fetchProfiles()
         }
     }

    
    private func fetchProfilesAgain() {
        fetchProfiles()
    }
    
    
    private func fetchProfiles() {
        FirebaseService().fetchProfiles { fetchedProfiles in
            self.profiles = fetchedProfiles
        }
    }
    
    
    
    private var filteredProfiles: [RetrievedProfile] {
        profiles.filter { $0.email != sessionManager.email }
    }

    private func removeCurrentProfile() {
        if !filteredProfiles.isEmpty {
            // Remove the current profile
            profiles.removeAll { $0.id == filteredProfiles[currentIndex].id }

            // Reset currentIndex if it's out of bounds
            if currentIndex >= filteredProfiles.count {
                currentIndex = 0
            }
        }
    }}
struct ProfileStackView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleProfiles = [
            RetrievedProfile(
                age: 24,
                bio: "Sample bio...",
                ethnicity: "Sample Ethnicity",
                firstName: "John",
                gender: "Male",
                id: "sample-id-1",
                imageNames: ["image1", "image2"],
                interests: ["Music", "Art"],
                lookingFor: "Friendship",
                photoURLs: ["https://example.com/photo1.jpg"],
                rateSum: 10,
                rating: 5,
                timesRated: 2,
                email: "John@aol.com"
            ),
            // Add more sample profiles as needed
        ]

        ProfileStackView(profiles: .constant(sampleProfiles))
    }
}
