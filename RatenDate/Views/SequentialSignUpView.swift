import SwiftUI
import CoreLocation
import Firebase

struct SequentialSignUpView: View {
    @State private var name = ""
    @State private var location = CLLocation()
    @State private var occupation = ""
    @State private var age: Int = 18
    @State private var gender = ""
    @State private var ethnicity = ""
    @State private var height = ""
    @State private var bio = ""
    @State private var interests = ""
    @State private var lookingFor = ""
    @State private var currentStep = 1
    @State private var photoURLs = [String]()  // To hold the photo URLs
    @State private var profileID: String?  // To store the profile's unique ID

    var body: some View {
        VStack {
            if currentStep == 1 {
                // Replace with your GenericInfoView
                GenericInfoView(name: $name, location: $location, occupation: $occupation) {
                    setProfileIDIfNeeded()
                    currentStep += 1  // Move to the next step when 'Next' is tapped
                }
            } else if currentStep == 2 {
                // Replace with your DemographicInfoView
                DemographicInfoView(age: $age, gender: $gender, ethnicity: $ethnicity, height: $height) {
                    setProfileIDIfNeeded()
                    currentStep += 1
                }
            } else if currentStep == 3 {
                if let profileID = profileID {
                    PhotoUploadView(
                        photoURLs: $photoURLs,
                        onPhotosUploaded: {
                            // Move to the next step only after all photos are uploaded
                            currentStep = 4
                        },
                        profileID: profileID
                    )
                } else {
                    Text("Error: Profile ID is missing. Please restart the sign-up process.")
                }
            } else if currentStep == 4 {
                // Replace with your PersonalInfoView
                PersonalInfoView(bio: $bio, interests: $interests, lookingFor: $lookingFor) {
                    submitProfile()  // Call submitProfile() when 'Complete Sign Up' is tapped
                }
            }
        }
        .onAppear {
            setProfileIDIfNeeded()
        }
    }

    private func setProfileIDIfNeeded() {
        if profileID == nil {
            profileID = UUID().uuidString  // Initialize the UUID
        }
    }
    
    func submitProfile() {
        // Call this function only after all photos are uploaded (currentStep should be 4)

        guard let profileID = profileID else {
            print("Profile ID is nil. Cannot submit profile.")
            return
        }
        let newProfile = Profile(
            // If Profile expects an id, use the following line:
            // id: UUID(uuidString: profileID) ?? UUID(),
            
            // If Profile doesn't expect an id and generates it internally, remove the id line entirely
            imageNames: interests.components(separatedBy: ","),
            location: location,
            age: age,
            gender: gender,
            ethnicity: ethnicity,
            bio: bio,
            interests: interests.components(separatedBy: ","),
            lookingFor: lookingFor,
            photoURLs: photoURLs
        )


        // Save the profile to Firestore
        saveProfileToFirebase(profile: newProfile)

        print("User signed up with the following profile: \(newProfile)")
    }

    func saveProfileToFirebase(profile: Profile) {
        let db = Firestore.firestore()

        db.collection("profiles").document(profile.id.uuidString).setData(profile.dictionary) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Profile successfully added!")
                // Here, you might navigate the user to another part of your app
            }
        }
    }
}

struct SequentialSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SequentialSignUpView()
    }
}

