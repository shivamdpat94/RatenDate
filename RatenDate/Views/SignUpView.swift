////
////  SignUpView.swift
////  RatenDate
////
////  Created by Shivam Patel on 1/1/24.
////
//
//import SwiftUI
//import CoreLocation
//import FirebaseFirestore
//
//
//struct SignUpView: View {
//    @State private var name = ""
//    @State private var location = CLLocation()
//    @State private var occupation = ""
//    @State private var age: Int = 18
//    @State private var gender = ""
//    @State private var ethnicity = ""
//    @State private var height = ""
//    @State private var bio = ""
//    @State private var interests = ""
//    @State private var lookingFor = ""
//    @State private var currentStep = 1  // Add a state to track the current step
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                if currentStep == 1 {
//                    GenericInfoView(name: $name, location: $location, occupation: $occupation) {
//                        currentStep += 1  // Move to the next step when 'Next' is tapped
//                    }
//                } else if currentStep == 2 {
//                    DemographicInfoView(age: $age, gender: $gender, ethnicity: $ethnicity, height: $height) {
//                        currentStep += 1
//                    }
//                } else if currentStep == 3 {
//                    PersonalInfoView(bio: $bio, interests: $interests, lookingFor: $lookingFor) {
//                        signUp()  // Call signUp() when 'Complete Sign Up' is tapped
//                    }
//                }
//            }
//            .navigationBarTitle("Sign Up")
//        }
//    }
//    
//    func signUp() {
//        // Validate the fields and create a Profile instance
//        let newProfile = Profile(
//            imageNames: interests.components(separatedBy: ","), // Assuming imageNames are provided in the interests field for demonstration
//            location: location,
//            age: age,
//            gender: gender,
//            ethnicity: ethnicity,
//            bio: bio,
//            interests: interests.components(separatedBy: ","),
//            lookingFor: lookingFor
//        )
//
//        // Further actions after creating the profile, like saving it or sending it to a server...
//        print("User signed up with the following profile: \(newProfile)")
//    }
//
//}
//
//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
