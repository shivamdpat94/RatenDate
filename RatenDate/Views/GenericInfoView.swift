//
//  GenericInfoView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/1/24.
//

import SwiftUI
import CoreLocation
import Firebase


struct GenericInfoView: View {
    @Binding var name: String
    @StateObject private var locationManager = LocationManager()
    @Binding var occupation: String
    @State private var userInputCity: String = ""  // User-typed city
    @Binding var location: CLLocation  // Bind to the location in the parent view
    @Binding var email: String
    @Environment(\.presentationMode) var presentationMode  // To control the navigation stack
    @State private var showAlert = false  // To control the alert presentation
    @Binding var password: String  // Continue to use this to collect the password input
    var onNext: () -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Generic Information")) {
                TextField("Name", text: $name)
                
                HStack {
                    // Location TextField
                    TextField("City", text: $userInputCity)
                        .onReceive(locationManager.$placemark) { placemark in
                            if let city = placemark?.locality, let state = placemark?.administrativeArea {
                                userInputCity = "\(city), \(state)"
                            }
                        }
                        .onReceive(locationManager.$location) { newLocation in
                            if let newLocation = newLocation {
                                self.location = newLocation  // Update the bound location with the new value
                            }
                        }
                }
                
                TextField("Occupation", text: $occupation)
                TextField("Email", text: $email)
                SecureField("Password", text: $password)

            }
            
            Button("Next") {
                checkIfProfileExists()
            }
        }
        .onAppear {
            locationManager.requestPermission()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Email is already registered"),
                message: Text("Try logging in."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    private func checkIfProfileExists() {
        let db = Firestore.firestore()

        db.collection("profiles").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error checking for existing profile: \(error.localizedDescription)")
                return
            }

            if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
                showAlert = true  // Trigger the alert
                 presentationMode.wrappedValue.dismiss()  // Dismiss to previous view
            } else {
                print("New Profile") 
                onNext()
                // The email is not registered
                // Here you might call onNext() or proceed with creating a new profile
            }
        }
    }
    
}


struct GenericInfoView_Previews: PreviewProvider {
    @State static var dummyLocation = CLLocation(latitude: 40.7128, longitude: -74.0060)  // Example coordinates (New York City)

    static var previews: some View {
        GenericInfoView(
            name: .constant("John Doe"),
            occupation: .constant("Software Developer"),
            location: $dummyLocation,
            email: .constant("Email@email.com"),
            password: .constant(""),
            onNext: {}
        )
    }
}
