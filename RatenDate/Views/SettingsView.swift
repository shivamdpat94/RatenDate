//
//  SettingsView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/5/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var sessionManager: UserSessionManager

    var body: some View {
        VStack {
            if let userEmail = sessionManager.userEmail {
                Text(userEmail)
                    .font(.largeTitle)
            } else {
                Text("Not logged in")
                    .font(.largeTitle)
            }

            Button(action: {
                sessionManager.signOut {
                    // This block will be called after signing out is complete
                    // No need to change anything here unless you want to perform additional actions
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(UserSessionManager())
    }
}
