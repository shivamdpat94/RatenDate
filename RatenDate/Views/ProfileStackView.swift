import SwiftUI

struct ProfileStackView: View {
    @State private var profiles: [RetrievedProfile]
    @State private var currentIndex: Int = 0
    @EnvironmentObject var sessionManager: UserSessionManager

    init(profiles: [RetrievedProfile] = []) {
        _profiles = State(initialValue: profiles)
    }

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
                } else {
                    Text("No profiles available.")
                }

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
            }
            .padding(.bottom, 100)
        }
        .onAppear {
            if profiles.isEmpty {
                FirebaseService().fetchProfiles { fetchedProfiles in
                    self.profiles = fetchedProfiles
                }
            }
        }
    }

    private var filteredProfiles: [RetrievedProfile] {
        profiles.filter { $0.email != sessionManager.email }
    }

    private func removeCurrentProfile() {
        if filteredProfiles.count > 1 {
            currentIndex = (currentIndex + 1) % filteredProfiles.count
        } else {
            profiles.removeAll()
            currentIndex = 0
        }
    }
}
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

        ProfileStackView(profiles: sampleProfiles)
    }
}
