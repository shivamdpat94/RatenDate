//
//  LoginView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/3/24.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @EnvironmentObject var sessionManager: UserSessionManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoginSuccessful = false

    var body: some View {
        NavigationView {
            VStack {
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

                // This empty navigation link will trigger when isLoginSuccessful is set to true
                NavigationLink(destination: MainTabView(), isActive: $isLoginSuccessful) {
                    EmptyView()
                }
            }
        }
    }
    
    func loginUser(email: String, password: String) {
        sessionManager.signIn(email: email, password: password) {
            if sessionManager.isAuthenticated {
                // Navigate to MainTabView by replacing the root view
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: MainTabView().environmentObject(sessionManager))
                    window.makeKeyAndVisible()
                }
            } else {
                self.errorMessage = "Failed to login. Please check your credentials."
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
