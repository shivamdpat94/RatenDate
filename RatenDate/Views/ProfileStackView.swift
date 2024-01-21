import SwiftUI
import CoreLocation
import FirebaseFirestore

struct ProfileStackView: View {
    @Binding var profiles: [Profile]
    @State private var currentIndex: Int = 0
    @EnvironmentObject var sessionManager: UserSessionManager
    @State private var currentUserProfile: Profile?

    
    
    var body: some View {
        ZStack {
            Image("lemonfinal")
                .resizable()
                .scaledToFill()
                .opacity(0.25)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if !filteredProfiles.isEmpty && filteredProfiles.indices.contains(currentIndex) {
                    ProfileView(profile: filteredProfiles[currentIndex])
                        .transition(.slide)
                    
                    HStack {
                        Button("Dislike") {
                            dislikeCurrentProfile()
                            withAnimation {
                                removeCurrentProfile()
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        
                        Button("Like") {
                            likeCurrentProfile()
                            withAnimation {
                                removeCurrentProfile()
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        
                        Button("Next") {
                            withAnimation {
                                removeCurrentProfile()
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        
                    }
                    
                    
                } else {
                    Text("No profiles available.")
                    Button(action: fetchProfiles) {
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
            fetchCurrentUserProfile()
        }
        
    }
    
    private func fetchCurrentUserProfile() {
        FirebaseService().fetchProfile(email: sessionManager.email ?? "") { profile in
            self.currentUserProfile = profile
        }
    }
    private func dislikeCurrentProfile() {
        guard !filteredProfiles.isEmpty else { return }
        let dislikedProfileEmail = filteredProfiles[currentIndex].email

        FirebaseService().fetchProfile(email: sessionManager.email ?? "") { currentUserProfile in
            guard var userProfile = currentUserProfile else { return }
            let currentUserEmail = userProfile.email

            // Add liked profile's phone number to current user's likeSet
            userProfile.dislikeSet.insert(dislikedProfileEmail)
            
            // Update current user's profile
            FirebaseService().updateProfile(profile: userProfile) { success in
                if success {
                    print("Successfully updated user profile with like.")
                } else {
                    print("Failed to update user profile.")
                }
            }
        }
    }
    private func likeCurrentProfile() {
        guard !filteredProfiles.isEmpty else { return }
        let likedProfileEmail = filteredProfiles[currentIndex].email

        FirebaseService().fetchProfile(email: sessionManager.email ?? "") { currentUserProfile in
            guard var userProfile = currentUserProfile else { return }
            let currentUserEmail = userProfile.email

            // Add liked profile's phone number to current user's likeSet
            userProfile.likeSet.insert(likedProfileEmail)
            
            // Update current user's profile
            FirebaseService().updateProfile(profile: userProfile) { success in
                if success {
                    print("Successfully updated user profile with like.")
                } else {
                    print("Failed to update user profile.")
                }
            }

            // Check if mutual like exists
            print("Checking for mutual likes")
            self.checkForMutualLike(currentUserEmail: currentUserEmail,
                                    likedProfileEmail: likedProfileEmail)
        }
    }

    private func checkForMutualLike(currentUserEmail: String, likedProfileEmail: String) {
        FirebaseService().fetchProfile(email: likedProfileEmail) { likedUserProfile in
            guard var likedProfile = likedUserProfile else { return }
            if likedProfile.likeSet.contains(currentUserEmail) {
                // It's a match - concatenate and update matchSet for both users
                let concatenatedEmail = [currentUserEmail, likedProfileEmail].sorted().joined(separator: "")
                likedProfile.matchSet.insert(concatenatedEmail)
                FirebaseService().updateProfile(profile: likedProfile) { success in
                    // Handle the update result
                }

                // Update matchSet for the current user as well
                FirebaseService().fetchProfile(email: currentUserEmail) { currentUserProfile in
                    guard var currentUser = currentUserProfile else { return }
                    currentUser.matchSet.insert(concatenatedEmail)
                    FirebaseService().updateProfile(profile: currentUser) { success in
                        // Handle the update result
                    }
                    
                    // Create a new match document in Firestore
                    self.createMatchDocument(concatenatedEmail: concatenatedEmail)
                }
            }
        }
    }

    private func createMatchDocument(concatenatedEmail: String) {
        let db = Firestore.firestore()
        let matchDocument = db.collection("Matches").document(concatenatedEmail)
        matchDocument.setData(["Chat": []]) { error in
            if let error = error {
                print("Error creating match document: \(error)")
            } else {
                print("Match document successfully created!")
            }
        }
    }
    
    
    
    
 
    
    
    private func fetchProfiles() {
        FirebaseService().fetchProfiles { fetchedProfiles in
            self.profiles = fetchedProfiles
            preloadImages(for: Array(fetchedProfiles.prefix(10)))
            self.currentIndex = 0
        }
    }

    
    
    private var filteredProfiles: [Profile] {
        guard let currentUserProfile = currentUserProfile else { return [] }
        return profiles.filter { profile in
            profile.email != sessionManager.email &&
            !currentUserProfile.likeSet.contains(profile.email) &&
            !currentUserProfile.dislikeSet.contains(profile.email)
        }
    }
 
    private func removeCurrentProfile() {
        if !filteredProfiles.isEmpty {
            // Remove the current profile
            profiles.removeAll { $0.id == filteredProfiles[currentIndex].id }
            
            // Update currentIndex
            currentIndex = min(filteredProfiles.count - 1, currentIndex)
        }
    }

    
    private func preloadImages(for profiles: [Profile]) {
        let profilesToPreload = Array(profiles.prefix(10))

        for profile in profilesToPreload {
            for url in profile.photoURLs {
                guard let imageUrl = URL(string: url) else { continue }
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    guard let data = data, let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        ImageCache.shared.setImage(image, forKey: url)
                    }
                }.resume()
            }
        }
    }

   
}



struct ProfileStackView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a CLLocation instance for sample profiles
        let sampleLocation = CLLocation(latitude: 40.7128, longitude: -74.0060)

        // Create dictionaries representing sample profiles
        let sampleProfileData1: [String: Any] = [
            "age": 24,
            "bio": "Sample bio...",
            "ethnicity": "Sample Ethnicity",
            "firstName": "John",
            "gender": "Male",
            "id": "sample-id-1",
            "traits": ["Music", "Art"],
            "lookingFor": "Friendship",
            "photoURLs": ["https://example.com/photo1.jpg"],
            "rateSum": 10,
            "rating": 5,
            "timesRated": 2,
            "email": "John@aol.com",
            "location": sampleLocation        ]

        // Initialize Profile instances using the dictionaries
        let sampleProfiles = [Profile(dictionary: sampleProfileData1)]
        // Add additional profiles to the array as needed

        // Create a dummy UserSessionManager instance
        let dummySessionManager = UserSessionManager()

        return ProfileStackView(profiles: .constant(sampleProfiles))
            .environmentObject(dummySessionManager) // Provide the UserSessionManager as an environment object
    }
}
