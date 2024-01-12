import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var sessionManager: UserSessionManager
    @State private var showContentView = false

    var body: some View {
        ZStack {
            Image("lemonfinal")
                .resizable()
                .scaledToFill()
                .opacity(0.25)
                .edgesIgnoringSafeArea(.all)

            VStack {
                if let email = sessionManager.email {
                    Text(email)
                        .font(.largeTitle)
                } else {
                    Text("Not logged in")
                        .font(.largeTitle)
                }

                Button(action: {
                    sessionManager.signOut {
                        // Update the state to show ContentView after sign out
                        self.showContentView = !sessionManager.isAuthenticated
                    }
                }) {
                    Text("Sign Out")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 280, height: 60)
                        .background(Color.red)
                        .cornerRadius(15.0)
                }
            }
        }
        .fullScreenCover(isPresented: $showContentView) {
            ContentView()
        }
        .onChange(of: sessionManager.isAuthenticated) { newValue in
            showContentView = !newValue
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(UserSessionManager())
    }
}
