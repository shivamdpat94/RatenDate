//
//  RatenDateApp.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/1/24.
//

import SwiftUI
import Firebase

@main
struct RatenDateApp: App {
    @StateObject var sessionManager = UserSessionManager()
    @State var isShowingLoadingScreen = true // State to control the display of the LoadingView
    
    
    
    init() {
        FirebaseApp.configure()

        // Print all available fonts
        for family in UIFont.familyNames.sorted() {
            let fonts = UIFont.fontNames(forFamilyName: family)
            print("\(family): \(fonts)")
        }    }

    var body: some Scene {
        WindowGroup {
            // Determine which view to show based on the isShowingLoadingScreen state
            if isShowingLoadingScreen {
                LoadingView()
                    .onAppear {
                        // Transition to the ContentView after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isShowingLoadingScreen = false
                        }
                    }
            } else {
                ContentView() // Or your initial view
                    .environmentObject(sessionManager) // Provide the sessionManager to the views
            }
        }

    }
}





