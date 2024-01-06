//
//  UserSessionManager.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/5/24.
//

import SwiftUI
import FirebaseAuth

class UserSessionManager: ObservableObject {
    @Published var userEmail: String?
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?  // To hold error messages

    init() {
        setupAuthListener()
    }

    func setupAuthListener() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if let user = user {
                // User is signed in
                self?.isAuthenticated = true
                self?.userEmail = user.email
            } else {
                // User is signed out
                self?.isAuthenticated = false
                self?.userEmail = nil
            }
        }
    }

    func checkAuthStatus() {
        if let user = Auth.auth().currentUser {
            // User is signed in
            self.isAuthenticated = true
            self.userEmail = user.email
        } else {
            // No user is signed in
            self.isAuthenticated = false
            self.userEmail = nil
        }
    }
    
    
    
    // Sign-in method with improved error handling
    func signIn(email: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                self?.isAuthenticated = false
            } else if let userEmail = authResult?.user.email {
                self?.userEmail = userEmail
                self?.isAuthenticated = true
            }
            completion()
        }
    }

    // Sign-up method with improved error handling
    func signUp(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print("Sign up error: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
                return
            }
            if let userEmail = authResult?.user.email {
                print("Sign Up Successful")
                self?.userEmail = userEmail
                self?.isAuthenticated = true
                completion(true, nil)
            } else {
                completion(false, "Failed to retrieve user email.")
            }
        }
    }


    // Sign-out method
    func signOut(completion: @escaping () -> Void) {
        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
            self.userEmail = nil
            completion()  // Notify that sign-out is complete
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            errorMessage = signOutError.localizedDescription
        }
    }

    // Other methods as needed
}
