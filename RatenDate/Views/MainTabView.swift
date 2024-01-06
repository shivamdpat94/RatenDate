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
        NavigationLink(destination: MainTabView(), isActive: $isLoginSuccessful) {
            EmptyView()
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
