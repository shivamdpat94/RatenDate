//import SwiftUI
//import Firebase
//
//struct EmailPassView: View {
//    @Binding var email: String
//    @Binding var password: String
//    @Binding var phoneNumber: String
//
//    @State private var formattedPhoneNumber: String = ""
//    
//    var onNext: () -> Void
//
//    var body: some View {
//        Form {
//            Section(header: Text("Your Credentials")) {
//                TextField("Email", text: $email)
//                SecureField("Password", text: $password)
//                TextField("Cell Phone", text: $formattedPhoneNumber)
//                    .keyboardType(.numberPad)
//                    .onReceive(formattedPhoneNumber.publisher.collect()) {
//                        let digits = String($0).filter { "0"..."9" ~= $0 }
//                        if digits != phoneNumber {
//                            phoneNumber = digits
//                            formattedPhoneNumber = format(phoneNumber: digits)
//                        }
//                    }
//            }
//            
//            Button("Next") {
//                onNext()
//            }
//        }
//    }
//
//    private func format(phoneNumber: String) -> String {
//        let zip = phoneNumber.prefix(3)
//        let middle = phoneNumber.dropFirst(3).prefix(3)
//        let rest = phoneNumber.dropFirst(6)
//
//        return [zip, middle, rest]
//            .filter { !$0.isEmpty }
//            .joined(separator: "-")
//            .prefix(12) // Limit to 12 characters including dashes
//            .description
//    }
//}
//
//struct EmailPassView_Previews: PreviewProvider {
//    @State static var email = ""
//    @State static var password = ""
//    @State static var phoneNumber = ""
//    static var previews: some View {
//        EmailPassView(email: $email, password: $password, phoneNumber: $phoneNumber) {
//            // Actions to perform on 'Next'
//        }
//    }
//}


import SwiftUI
import Firebase

struct EmailPassView: View {
    @Binding var email: String
    @Binding var password: String
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
                    Image("glacier")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 90)
                        .padding(.bottom, 10)

                    Text("Welcome to")
                        .font(.system(size: 22))
                        .multilineTextAlignment(.center)

                    Image("ICEBREAKER")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 60)

                    GeometryReader { geometry in
                        VStack {
                            TextField("Email", text: $email)
                                .padding() // Adds internal padding to the text field
                                .background(RoundedRectangle(cornerRadius: 25)
                                                .fill(Color(hex: "2F382D").opacity(0.30)))
                                .foregroundColor(.white) // Attempts to set the text color, but primarily affects placeholder
                                .padding(.horizontal, 15) // Apply consistent horizontal padding

                            Spacer(minLength: 10)
                        
                            SecureField("Password", text: $password)
                                .padding() // Adds internal padding to the secure field
                                .background(RoundedRectangle(cornerRadius: 25)
                                                .fill(Color(hex: "2F382D").opacity(0.30)))
                                .foregroundColor(.white) // As above, primarily affects placeholder visibility
                                .padding(.horizontal, 15)
                            
                            SecureField("Confirm Password", text: $password)
                                .padding() // Adds internal padding to the secure field
                                .background(RoundedRectangle(cornerRadius: 25)
                                                .fill(Color(hex: "2F382D").opacity(0.30)))
                                .foregroundColor(.white) // As above, primarily affects placeholder visibility
                                .padding(.horizontal, 15)

                        
                            
                            Spacer(minLength: 25)

                            Button(action: {
//                                loginUser(email: email, password: password)
                                onNext()
                            }) {
                                HStack {
                                    Text("Sign Up")
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
                            
                            Button(action: {
                                // Action for the "Already have an account?" button
                                // For example, switch to the login view
                                // loginUser(email: email, password: password)
                                onNext() // Assuming onNext() navigates to the login screen
                            }) {
                                Text("Already have an account?")
                                    .font(.body)
                                    .foregroundColor(.blue) // Use a color that matches your app's theme or provides good contrast with the background
                            }
                            .padding(.top, 10)



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

struct EmailPassView_Previews: PreviewProvider {
    static var previews: some View {
        EmailPassView(email: .constant("example@example.com"),
                      password: .constant("password123"),
                      phoneNumber: .constant("1234567890")) {
            // This is where you define what happens when the 'Next' button is pressed.
            // For preview purposes, you can leave this empty or print something to the console.
            print("Next button pressed")
        }
        // Optionally add environment objects or other modifiers necessary for the preview
    }
}
