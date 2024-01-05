//
//  SequentialSignUpView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/1/24.
//

// SequentialSignUpView.swift

import SwiftUI
import CoreLocation
import Firebase
import FirebaseStorage  // Ensure you've added Firebase Storage to your project

struct SequentialSignUpView: View {
    @State private var firstName = ""
    @State private var location = CLLocation()
    @State private var occupation = ""
    @State private var age: Int = 18
    @State private var gender = ""
    @State private var email = ""
    @State private var password = ""
    @State private var ethnicity = ""
    @State private var phoneNumber = ""
    @State private var height = ""
    @State private var bio = ""
    @State private var interests = ""
    @State private var lookingFor = ""
    @State private var currentStep = 1
    @State private var photoURLs = [String]()  // To hold the photo URLs
    @State private var profileID: String?  // To store the profile's unique ID
    @State private var selectedImages: [Int: UIImage] = [:]  // To hold the selected images
    @State private var navigateToProfileStack = false  // State to control navigation

    var body: some View {
        VStack {
            if currentStep == 1 {
                GenericInfoView(
                    name: $firstName,
                    occupation: $occupation,
                    location: $location,  // Bind the location
                    email: $email,
                    password: $password,
                    onNext: {
                        setProfileIDIfNeeded()
                        currentStep += 1
                    }
                )
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
                        selectedImages: $selectedImages,  // Pass the Binding to the selected images
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
            // NavigationLink that triggers navigation when navigateToProfileStack is true
            NavigationLink(destination: ProfileStackView(), isActive: $navigateToProfileStack) {
                EmptyView()  // This doesn't create a visible UI element but enables programmatic navigation
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
        guard let safeProfileID = profileID else {
            print("Profile ID is nil. Cannot submit profile.")
            return
        }

        // First, upload the images
        uploadImages { uploadedURLs in
            // Once the images are uploaded, create the profile with the URLs
            let newProfile = Profile(
                // If Profile expects an id, use the following line:
                // id: UUID(uuidString: profileID) ?? UUID(),
                
                // If Profile doesn't expect an id and generates it internally, remove the id line entirely
                imageNames: self.interests.components(separatedBy: ","),
                location: self.location,
                age: self.age,
                id: safeProfileID,
                email: self.email,
                password: self.password,
                gender: self.gender,
                ethnicity: self.ethnicity,
                firstName: self.firstName,
                bio: self.bio,
                interests: self.interests.components(separatedBy: ","),
                lookingFor: self.lookingFor,
                photoURLs: uploadedURLs  // Use the URLs from the uploaded images
            )

            // Save the profile to Firestore
            FirebaseService().saveProfileToFirebase(profile: newProfile) {
                // Trigger navigation to ProfileStackView after the profile is successfully saved
                self.navigateToProfileStack = true
            }
        }
    }

    
    
    
    
    func uploadImages(completion: @escaping ([String]) -> Void) {
        let storage = Storage.storage()
        var uploadedURLs = [String]()
        let group = DispatchGroup()

        for (index, image) in selectedImages {
            group.enter()
            let photoRef = storage.reference().child("photos/\(phoneNumber)/photo\(index).jpg")
            
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                photoRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print("Error uploading image: \(error.localizedDescription)")
                        group.leave()
                        return
                    }

                    photoRef.downloadURL { (url, error) in
                        if let downloadURL = url {
                            uploadedURLs.append(downloadURL.absoluteString)
                        } else {
                            print(error?.localizedDescription ?? "Unknown error")
                        }
                        group.leave()
                    }
                }
            } else {
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(uploadedURLs)
        }
    }
}

struct SequentialSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SequentialSignUpView()
    }
}

