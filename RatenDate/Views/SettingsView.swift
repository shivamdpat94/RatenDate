import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var sessionManager: UserSessionManager

    var body: some View {
        ZStack {
            Image("lemonfinal")
                .resizable()
                .scaledToFill()
                .opacity(0.25)
                .edgesIgnoringSafeArea(.all)

            VStack {
                if let userEmail = sessionManager.userEmail {
                    Text(userEmail)
                        .font(.largeTitle)
                } else {
                    Text("Not logged in")
                        .font(.largeTitle)
                    
                }

                Button(action: {
                    // Call signOut with a completion handler
                    sessionManager.signOut {
                        // Actions after signing out, if any
                        // You can leave this empty if there's nothing to do
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
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(UserSessionManager())
    }
}
