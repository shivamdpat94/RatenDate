//
//  UserSessionManager.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/5/24.
//

import SwiftUI
import FirebaseAuth

class UserSessionManager: ObservableObject {
    @Published var email: String?
    @Published var phoneNumber: String?
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
                self?.email = user.email
                self?.phoneNumber = user.phoneNumber
            } else {
                // User is signed out
                self?.isAuthenticated = false
                self?.email = nil
                self?.phoneNumber = nil
            }
        }
    }
    
    func checkAuthStatus() {
        if let user = Auth.auth().currentUser {
            // User is signed in
            self.isAuthenticated = true
            self.email = user.email
            self.phoneNumber = user.phoneNumber
        } else {
            // No user is signed in
            self.isAuthenticated = false
            self.email = nil
            self.phoneNumber = nil
        }
    }
    
    
    
    // Sign-in method with improved error handling
    func signIn(email: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                self?.isAuthenticated = false
            } else if let email = authResult?.user.email {
                self?.email = email
                self?.phoneNumber = authResult?.user.phoneNumber  // If available
                self?.isAuthenticated = true
            }
            completion()
        }
    }

    
    // Sign-up method with improved error handling
    func signUp(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Sign up error: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            } else if let email = authResult?.user.email {
                // Update class properties
                self.email = email
                self.isAuthenticated = true
                
                // Fetch and update FCM token after successful sign-up
                FCMTokenManager.fetchFCMToken { token in
                    guard let token = token else {
                        completion(true, "User created but failed to fetch FCM token.")
                        return
                    }
                    
                    // Update the user's FCM token in Firestore or your backend
                    FCMTokenManager.updateUserFCMToken(email: email, token: token) {
                        completion(true, nil) // Complete the sign-up process
                    }
                }
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
            self.email = nil
            completion()  // Notify that sign-out is complete
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            errorMessage = signOutError.localizedDescription
        }
    }
    
}
