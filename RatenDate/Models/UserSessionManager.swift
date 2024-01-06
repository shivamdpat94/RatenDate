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

    // Sign-in and Sign-out methods
    func signIn(email: String, password: String) {
        // Implement sign-in method
    }

    func signOut() {
        try? Auth.auth().signOut()
    }

    // Other methods as needed
}
