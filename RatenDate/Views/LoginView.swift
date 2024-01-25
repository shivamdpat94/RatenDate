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

                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.7)))
                        .foregroundColor(.black)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.7)))
                        .foregroundColor(.black)

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }

                    // Centering the 'Login' button using HStack
                    HStack {
                        Spacer() // Spacer on the left side
                        
                        Button("Login") {
                            loginUser(email: email, password: password)
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 280, height: 60)
                        .background(Color.black.opacity(0.7)) // Slight transparency for better visibility
                        .cornerRadius(15.0)
                        
                        Spacer() // Spacer on the right side
                    }

                    NavigationLink(destination: MainTabView(), isActive: $isLoginSuccessful) {
                        EmptyView()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Login")
                        .font(.custom("Nunito-Regular", size: 20)) // Set the font here
                }
            }        }
    }
    
    func loginUser(email: String, password: String) {
        sessionManager.signIn(email: email, password: password) {
            if sessionManager.isAuthenticated {
                // Fetch and update the FCM token after a successful login
                FCMTokenManager.fetchFCMToken { token in
                    guard let token = token else { return }
                    
                    // Update the user's FCM token in Firestore or your backend
                    FCMTokenManager.updateUserFCMToken(email: email, token: token)
                    
                    // After updating the token, navigate to MainTabView
                    DispatchQueue.main.async {
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: MainTabView().environmentObject(sessionManager))
                            window.makeKeyAndVisible()
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to login. Please check your credentials."
                }
            }
        }
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
