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
    @EnvironmentObject var sessionManager: UserSessionManager

    @State private var email = ""
    @State private var password = ""
    @State private var phoneNumber = ""

    
    
    @State private var firstName = ""
    @State private var location = CLLocation()
    @State private var dob: Date? = nil

    @State private var ethnicity: String?
    @State private var gender: String?
    @State private var height: String?


    @State private var lookingFor:  String?
    @State private var wantKids:  String?
    @State private var hasKids:  String?
    @State private var politics:  String?
    @State private var religion:  String?
    
    
    @State private var languages = [""]

        
    
    @State private var occupation = ""
    @State private var educationLevel = ""
    @State private var areaOfStudy = ""
    
    @State private var alcohol = ""
    @State private var cigerettes = ""
    @State private var drugs = ""
    


    


    
    @State private var bio = ""
    @State private var traits = [""]
    @State private var interests = [""]

    
    
    @State private var currentStep = 1
    @State private var photoURLs = [String]()  // To hold the photo URLs
    @State private var profileID: String?  // To store the profile's unique ID
    @State private var selectedImages: [Int: UIImage] = [:]  // To hold the selected images
    @State private var navigateToMainTabView = false  // State to control navigation


    var body: some View {
        VStack {
            if currentStep > 1 {
                Button("Back") {
                    // Decrement the current step to go back in the sequence
                    currentStep -= 1
                }
            }
            if currentStep == 1 {
                EmailPassView(email: $email,
                              password: $password,
                              phoneNumber: $phoneNumber) {
                    currentStep += 1
                }
            }
            if currentStep == 2 {
                GenericInfoView(
                    name: $firstName,
                    gender: $gender,
                    ethnicity: $ethnicity,
                    dob: $dob,
                    height: $height,
                    location: $location,  // Bind the location
                    onNext: {
                        currentStep += 1
                    }
                )
            } else if currentStep == 3 {
                
                
                // Replace with your DemographicInfoView
                LifestyleView(lookingFor: $lookingFor,
                              wantKids: $wantKids,
                              hasKids: $hasKids,
                              politics: $politics,
                              religion: $religion,
                    onNext: {
                    currentStep += 1
                    }
                )
                
            } else if currentStep == 4 {
                LanguageSelectionView(languages: $languages, onNext: {
                    currentStep += 1
                    }
                )
                
            } else if currentStep == 5 {
                PhotoUploadView(
                    photoURLs: $photoURLs,
                    selectedImages: $selectedImages,
                    onPhotosUploaded: {
                        currentStep += 1
                    }
                )
            } else if currentStep == 6 {
                // Replace with your PersonalInfoView
                TraitsAndInterestsView(traits: $traits, interests: $interests) {
                    submitProfile()  // Call submitProfile() when 'Complete Sign Up' is tapped
                    
                }
            }
            // NavigationLink that triggers navigation when navigateToProfileStack is true
            NavigationLink(destination: MainTabView(), isActive: $navigateToMainTabView) {
                EmptyView()  // This doesn't create a visible UI element but enables programmatic navigation
            }
        }
    }
    
  
    
    
    func submitProfile() {
        sessionManager.signUp(email: email, password: password) { success, errorMessage in
            if success {
                // First, upload the images
                self.uploadImages { uploadedURLs in
                    // Calculate age from dob
                    let age = self.calculateAge()

                    // Create a dictionary for the profile data including all fields
                    let profileData: [String: Any] = [
                        "location": GeoPoint(latitude: self.location.coordinate.latitude, longitude: self.location.coordinate.longitude),
                        "age": age,
                        "email": self.email,
                        "gender": self.gender,
                        "ethnicity": self.ethnicity,
                        "firstName": self.firstName,
                        "bio": self.bio,
                        "traits": self.traits,
                        "lookingFor": self.lookingFor,
                        "photoURLs": uploadedURLs,
                        "rateSum": 0.0,
                        "timesRated": 0.0,
                        "rating": 0.0,
                        // Add the new fields here
                        "password": self.password,
                        "phoneNumber": self.phoneNumber,
                        "dob": self.dob,
                        "height": self.height,
                        "wantKids": self.wantKids,
                        "hasKids": self.hasKids,
                        "politics": self.politics,
                        "religion": self.religion,
                        "languages": self.languages,
                        "occupation": self.occupation,
                        "educationLevel": self.educationLevel,
                        "areaOfStudy": self.areaOfStudy,
                        "alcohol": self.alcohol,
                        "cigerettes": self.cigerettes,
                        "drugs": self.drugs,
                        "interests": self.interests
                    ]

                    // Initialize the profile with the dictionary
                    let newProfile = Profile(dictionary: profileData)
                    
                    print("again name is")
                    print(firstName)
                    print(newProfile.firstName)
                    print("again height is ")
                    print(height)
                    print(newProfile.height)
                    // Save the profile to Firestore
                    FirebaseService().saveProfileToFirebase(profile: newProfile) {
                        // Trigger navigation to MainTabView after the profile is successfully saved
                        DispatchQueue.main.async {
                            self.navigateToMainTabView = true
                        }
                    }
                }
            } else if let errorMessage = errorMessage {
                print("Sign Up Error: \(errorMessage)")
                // Handle sign-up error
            }
        }
    }


    func calculateAge() -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self.dob!, to: Date())
        return ageComponents.year ?? 0
    }
    
    func uploadImages(completion: @escaping ([String]) -> Void) {
        let storage = Storage.storage()
        var uploadedURLs = [String]()
        let group = DispatchGroup()

        for (index, image) in selectedImages {
            group.enter()
            let photoRef = storage.reference().child("photos/\(email)/photo\(index).jpg")
            
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

