//
//  LoginView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/3/24.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    @State private var verificationID: String? = nil  // To hold the verification ID from Firebase
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Phone Number")) {
                    TextField("Enter your phone number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .autocapitalization(.none)
                }
                
                if verificationID != nil {
                    Section(header: Text("Verification Code")) {
                        TextField("Enter the 6-digit code", text: $verificationCode)
                            .keyboardType(.numberPad)
                    }
                }
                
                Button(verificationID == nil ? "Send Verification Code" : "Log In") {
                    if verificationID == nil {
                        sendVerificationCode()
                    } else {
                        verifyCode()
                    }
                }
            }
            .navigationBarTitle("Log In")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func sendVerificationCode() {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                self.alertMessage = error.localizedDescription
                self.showingAlert = true
                return
            }
            self.verificationID = verificationID
        }
    }
    
    func verifyCode() {
        guard let verificationID = verificationID else { return }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                self.alertMessage = error.localizedDescription
                self.showingAlert = true
                return
            }
            // User is logged in, navigate to the main part of your app
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

