//
//  PhonePassView.swift
//  RatenDate
//
//  Created by Mitchell Buff on 2/6/24.
//

import SwiftUI
import Firebase

struct PhonePassView: View {
    @Binding var phoneNumber: String
    
    @EnvironmentObject var sessionManager: UserSessionManager
    @State private var errorMessage: String?
    @State private var isLoginSuccessful = false
    
    var onNext: () -> Void

    var body: some View {
        NavigationView {
            ZStack {
                Image("bg FLAKES BLUE")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

                VStack(alignment: .center, spacing: 10) {
                    
                    
                    Image("ICEBREAKER")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 210, height: 60)

                    Text("Verification")
                        .font(.system(size: 20))
                        .multilineTextAlignment(.center)
                    
                    Image("glacier")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                        .padding(.bottom, 10)
                    
                    Text("Enter Your Phone Number")
                        .font(.system(size: 20))
                        .multilineTextAlignment(.center)
                    
                    Text("We will send you a 4 digit verification code")
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                    
                    

                    GeometryReader { geometry in
                        VStack {
                            TextField("Phone Number", text: $phoneNumber)
                                .padding() // Adds internal padding to the text field
                                .background(RoundedRectangle(cornerRadius: 25)
                                                .fill(Color(hex: "2F382D").opacity(0.30)))
                                .foregroundColor(.white) // Attempts to set the text color, but primarily affects placeholder
                                .padding(.horizontal, 15) // Apply consistent horizontal padding


                            Button(action: {
//                                loginUser(email: email, password: password)
                                onNext()
                            }) {
                                HStack {
                                    Text("Send Code")
                                        .font(.body)
                                        .foregroundColor(.white)

                                    // Replace "iconNameLogin" with your actual icon name for the login button
                                    Image("login")
                                        .resizable() // Allows the image to be resized
                                        .aspectRatio(contentMode: .fit) // Keeps the aspect ratio of the image intact
                                        .frame(width: 20, height: 20) // Match the text color
                                }
                                .padding(.vertical, 15) // Adjusted vertical padding for the button content
                                .frame(maxWidth: 300) // Set the maximum width of the button content
                            }
                            .padding(.horizontal, 15) // Padding applied to the button itself, affecting the touch area and background
                            .background(Color(hex: "0399F5")) // Updated to use the specified blue color
                            .cornerRadius(30.0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30) // Match the cornerRadius value with the button's cornerRadius
                                    .stroke(Color(hex: "8B8B8B"), lineWidth: 0.25) // Thin black border with 1 point line width
                            )


                        }
                        
                        

                    }
                    .frame(height: 225) // Set an explicit height for the GeometryReader

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }

                    NavigationLink(destination: MainTabView(), isActive: $isLoginSuccessful) {
                        EmptyView()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, -50)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("")
                        .font(.custom("Nunito-Regular", size: 20))
                }
            }
        }
        
    }

    func loginUser(email: String, password: String) {
        sessionManager.signIn(email: email, password: password) {
            // Login logic
        }
    }
}

struct PhonePassView_Previews: PreviewProvider {
    static var previews: some View {
        PhonePassView(phoneNumber: .constant("770-910-0870")) {
            // This is where you define what happens when the 'Next' button is pressed.
            // For preview purposes, you can leave this empty or print something to the console.
            print("Next button pressed")
        }
        // Optionally add environment objects or other modifiers necessary for the preview
    }
}
