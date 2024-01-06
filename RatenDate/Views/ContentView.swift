import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionManager: UserSessionManager
    let darkOrange = Color(red: 1.0, green: 0.3, blue: 0, opacity: 1)

    var body: some View {
        NavigationView {
            // Check the authentication status from sessionManager
            if sessionManager.isAuthenticated {
                // User is authenticated, show the main tab view
                MainTabView()
            } else {
                // User is not authenticated, show login and sign up options
                VStack(spacing: 20) {
                    Text("Welcome to the App")
                        .font(.largeTitle)
                    
                    Spacer()
                    
                    // Button to navigate to the Login view
                    NavigationLink(destination: LoginView().environmentObject(sessionManager)) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 280, height: 60)
                            .background(darkOrange)
                            .cornerRadius(15.0)
                    }
                    
                    
                    // Button to navigate to the Sign Up view
                    NavigationLink(destination: SequentialSignUpView().environmentObject(sessionManager)) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 280, height: 60)
                            .background(darkOrange)
                            .cornerRadius(15.0)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(darkOrange)
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
