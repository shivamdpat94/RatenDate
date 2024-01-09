import SwiftUI

struct ProfileStackView: View {
    @State private var profiles: [RetrievedProfile]
    @State private var currentIndex: Int = 0

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
                if !profiles.isEmpty {
                    ProfileView(profile: profiles[currentIndex])
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

    private func removeCurrentProfile() {
        if profiles.count > 1 {
            profiles.remove(at: currentIndex)
        } else {
            profiles.removeAll()
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
                timesRated: 2
            ),
            // Add more sample profiles as needed
        ]

        ProfileStackView(profiles: sampleProfiles)
    }
}
