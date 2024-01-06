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
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView() // Or your initial view
                .environmentObject(sessionManager) // Provide the sessionManager to the views

        }
    }
}
