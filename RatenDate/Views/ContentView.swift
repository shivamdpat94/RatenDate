import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionManager: UserSessionManager

    var body: some View {
        NavigationView {
            // Check the authentication status from sessionManager
            if sessionManager.isAuthenticated {
                // User is authenticated, show the main tab view
                MainTabView()
            } else {
                // User is not authenticated, show login and sign up options
                VStack(spacing: 20) {
//                    Text("Welcome to the App")
//                        .font(.largeTitle)
//                        .foregroundColor(.white) // Ensuring text is visible on the background image
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    // Button to navigate to the Login view
                    NavigationLink(destination: LoginView().environmentObject(sessionManager)) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 280, height: 60)
                            .background(Color.black.opacity(0.7)) // Slight transparency for better visibility
                            .cornerRadius(15.0)
                    }
                    
                    
                    // Button to navigate to the Sign Up view
                    NavigationLink(destination: SequentialSignUpView().environmentObject(sessionManager)) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 280, height: 60)
                            .background(Color.black.opacity(0.7)) // Slight transparency for better visibility
                            .cornerRadius(15.0)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    // Set the image as the background
                    Image("LoginSignup")
                        .resizable() // Make the image resizable
                        .aspectRatio(contentMode: .fill) // Fill the entire view
                        .edgesIgnoringSafeArea(.all) // Extend the background image to the screen edges
                )
            }
        }
        .onAppear {
            // Optionally check the authentication status when the view appears
            sessionManager.checkAuthStatus()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserSessionManager())
    }
}
