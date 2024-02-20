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
                        
                            HStack {
                                Spacer() // Pushes the button to the right
                                Button(action: {
                                    // Insert action for forgot password here
                                }) {
                                    Text("Forgot Password?")
                                        .font(.body)
                                        .foregroundColor(.red) // Sets the text color to red
                                }
                            }
                            .padding(.horizontal, 15) // Ensures alignment with the above elements
                            
                            Spacer(minLength: 25)

                            Button(action: {
                                loginUser(email: email, password: password)
                            }) {
                                HStack {
                                    Text("Login")
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

                            Spacer(minLength: 10)

                            Button(action: {
                                // Adjust the action as necessary for account creation
                            }) {
                                HStack {
                                    Text("Create Account")
                                        .font(.body) // Changed from .headline to .body for a standard font weight
                                        .foregroundColor(.black) // Text color is black

                                    // Replace "iconNameCreateAccount" with your actual icon name for the create account button
                                    Image("add-circle")
                                        .resizable() // Allows the image to be resized
                                        .aspectRatio(contentMode: .fit) // Keeps the aspect ratio of the image intact
                                        .frame(width: 20, height: 20) // Specifies the new size of the image
                                }
                                .padding(.vertical, 15) // Controls the vertical padding inside the button
                                .frame(maxWidth: 300) // Sets the maximum width of the button text
                            }
                            .padding(.horizontal, 15) // Padding applied to the button itself, affecting the touch area and background
                            .background(Color.white.opacity(0.7)) // Background color applied after the padding to ensure it covers the desired area
                            .cornerRadius(30.0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30) // Match the cornerRadius value with the button's cornerRadius
                                    .stroke(Color.black, lineWidth: 0.25) // Thin black border with 1 point line width
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

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
