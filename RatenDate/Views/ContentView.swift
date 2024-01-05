import SwiftUI

struct ContentView: View {
    let darkOrange = Color(red: 1.0, green: 0.3, blue: 0, opacity: 1)
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to the App")
                    .font(.largeTitle)
                
                Spacer()
                
                // Button to navigate to the Login view
                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 280, height: 60)
                        .background(darkOrange)
                        .cornerRadius(15.0)
                }
                
                // Button to navigate to the Sign Up view
                NavigationLink(destination: SequentialSignUpView()) {
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
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand to fill the screen
            .background(darkOrange) // Set the background color to the custom dark orange
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
