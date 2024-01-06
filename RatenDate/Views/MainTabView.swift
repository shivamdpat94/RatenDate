//
//  TabView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/5/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var isLoginSuccessful: Bool = false

    var body: some View {
        TabView {
            ProfileStackView()
                .tabItem {
                    Image(systemName: "person.3.fill") // Customize this icon as needed
                    Text("Profiles")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear") // Customize this icon as needed
                    Text("Settings")
                }
        }
        .navigationBarBackButtonHidden(true) // This hides the back button
        .navigationBarHidden(true) // Optionally, this hides the entire navigation bar
        .navigationTitle("") // Clear any title that might take space
        .onAppear {
            self.isLoginSuccessful = true // Assuming you set this based on some condition
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
