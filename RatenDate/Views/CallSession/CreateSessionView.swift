//
//  CreateSessionView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/25/24.
//

import SwiftUI

struct CreateSessionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var callSessionManager: CallSessionManager
    @State private var sessionName: String = ""

    var body: some View {
        Form {
            TextField("Session Name", text: $sessionName)
            Button("Create Session") {
                callSessionManager.createSession(name: sessionName) { newSession in
                    // You might want to use the newSession for something, or check if it's nil
                    DispatchQueue.main.async {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .navigationBarTitle("New Session")
    }
}

// Define the preview provider
struct CreateSessionView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of CallSessionManager for the preview
        CreateSessionView(callSessionManager: CallSessionManager())
    }
}
