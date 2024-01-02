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
    @State private var selectedImages: [Int: UIImage] = [:]  // To hold the selected images

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
        guard let profileID = profileID else {
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
                gender: self.gender,
                ethnicity: self.ethnicity,
                bio: self.bio,
                interests: self.interests.components(separatedBy: ","),
                lookingFor: self.lookingFor,
                photoURLs: uploadedURLs  // Use the URLs from the uploaded images
            )

            // Save the profile to Firestore
            self.saveProfileToFirebase(profile: newProfile)
        }
    }

    
    
    
    
    func uploadImages(completion: @escaping ([String]) -> Void) {
        let storage = Storage.storage()
        var uploadedURLs = [String]()
        let group = DispatchGroup()

        for (index, image) in selectedImages {
            group.enter()
            let photoRef = storage.reference().child("photos/\(profileID!)/photo\(index).jpg")
            
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

