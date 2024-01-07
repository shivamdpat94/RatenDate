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
            ZStack {
                // Background image
                Image("LoginBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

                // Transparent content area
                VStack(alignment: .leading, spacing: 20) {
                    Text("Email")
                        .foregroundColor(.gray)
                    TextField("Enter your email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color.white.opacity(0.7)))
                        .foregroundColor(.black)

                    Text("Password")
                        .foregroundColor(.gray)
                    SecureField("Enter your password", text: $password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color.white.opacity(0.7)))
                        .foregroundColor(.black)

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }

                    Button("Login") {
                        loginUser(email: email, password: password)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    NavigationLink(destination: MainTabView(), isActive: $isLoginSuccessful) {
                        EmptyView()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarTitle("Login", displayMode: .inline)
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
