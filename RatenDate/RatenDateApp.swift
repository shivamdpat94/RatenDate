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
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView() // Or your initial view
        }
    }
}
