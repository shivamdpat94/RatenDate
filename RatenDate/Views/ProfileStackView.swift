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
                if !filteredProfiles.isEmpty {
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
      
                        Button("Next") {
                            withAnimation {
                                removeCurrentProfile()
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
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

            // Add liked profile's email to current user's likeSet
            userProfile.likeSet.insert(likedProfileEmail)
            
            // Update current user's profile
            FirebaseService().updateProfile(profile: userProfile) { success in
                if success {
                    print("Successfully updated user profile with like.")
                } else {
                    print("Failed to update user profile.")
                }
            }

            // Add current user's email to liked profile's likeMeSet
            FirebaseService().fetchProfile(email: likedProfileEmail) { likedProfile in
                guard var likedUser = likedProfile else { return }
                
                likedUser.likeMeSet.insert(currentUserEmail)
                
                // Update liked user's profile
                FirebaseService().updateProfile(profile: likedUser) { success in
                    if success {
                        print("Successfully updated liked user profile with current user's like.")
                    } else {
                        print("Failed to update liked user profile.")
                    }
                }
            }
        }
    }


    private func checkForMutualLike(currentUserEmail: String, likedProfileEmail: String) {
        FirebaseService().fetchProfile(email: likedProfileEmail) { likedUserProfile in
            guard var likedProfile = likedUserProfile else { return }
            if likedProfile.likeSet.contains(currentUserEmail) {
                // It's a match - concatenate and update matchSet for both users
                let concatenatedEmail = [currentUserEmail, likedProfileEmail].sorted().joined(separator: "")

                // Update the liked user's profile
                likedProfile.matchSet.insert(concatenatedEmail)
                FirebaseService().updateProfile(profile: likedProfile) { successLikedProfile in
                    if successLikedProfile {
                        // Update the current user's profile
                        FirebaseService().fetchProfile(email: currentUserEmail) { currentUserProfile in
                            guard var currentUser = currentUserProfile else { return }
                            currentUser.matchSet.insert(concatenatedEmail)
                            FirebaseService().updateProfile(profile: currentUser) { successCurrentUser in
                                if successCurrentUser {
                                    // Both profiles updated successfully, now create the chat document
                                    self.createMatchDocument(userEmail1: currentUserEmail, userEmail2: likedProfileEmail)
                                } else {
                                    print("Failed to update current user profile.")
                                }
                            }
                        }
                    } else {
                        print("Failed to update liked user profile.")
                    }
                }
            }
        }
    }


    private func createMatchDocument(userEmail1: String, userEmail2: String) {
        let db = Firestore.firestore()
        
        // Create the concatenated email as chatID
        let concatenatedEmail = [userEmail1, userEmail2].sorted().joined(separator: "")
        
        // Create a new chat document in the 'Chats' collection
        let chatDocument = db.collection("Chats").document(concatenatedEmail)
        
        // Initialize the chat document with the participants' emails
        chatDocument.setData([
            "createdDate": Timestamp(date: Date()),
            "participants": [userEmail1, userEmail2]  // Array containing both users' emails
        ]) { error in
            if let error = error {
                print("Error initializing chat document: \(error)")
            } else {
                print("Chat document successfully initialized!")

//                // Optionally, add an initial system message in 'Messages' subcollection
//                let initialMessage = [
//                    "text": "Chat started",
//                    "senderID": "system",
//                    "timestamp": Timestamp(date: Date())
//                ]
//                chatDocument.collection("Messages").document().setData(initialMessage) { error in
//                    if let error = error {
//                        print("Error adding initial message: \(error)")
//                    } else {
//                        print("Initial message added to chat")
//                    }
//                }
            }
        }
    }



    
    
    
    
 
    
    
    private func fetchProfiles() {
        FirebaseService().fetchProfiles { fetchedProfiles in
            self.profiles = fetchedProfiles
        }
    }
    
    
//    private var filteredProfiles: [Profile] {
//        profiles.filter { $0.email != sessionManager.email }
//    }
//
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
            
            // Reset currentIndex if it's out of bounds
            if currentIndex >= filteredProfiles.count {
                currentIndex = 0
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
