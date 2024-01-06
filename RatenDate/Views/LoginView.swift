//
//  LoginView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/3/24.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Email")) {
                    TextField("Enter your email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Password")) {
                    SecureField("Enter your password", text: $password)
                }
                
                if let errorMessage = errorMessage {
                    Section {
                        Text(errorMessage).foregroundColor(.red)
                    }
                }
                
                Section {
                    Button("Login") {
                        loginUser(email: email, password: password)
                    }
                }
            }
            .navigationBarTitle("Login")
        }
    }
    
    func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                // For more detailed debugging:
                print(error)
                return
            } 
            print("Login Successful")
            MainTabView()
            // Proceed if login is successful
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
