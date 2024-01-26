//
//  SessionDetailView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/25/24.
//

import SwiftUI

struct SessionDetailView: View {
    var session: CallSession
    @ObservedObject var callSessionManager: CallSessionManager

    var body: some View {
        VStack {
            Text("Session: \(session.name)")
            Button("Join Session") {
                callSessionManager.joinSession(sessionId: session.id)
            }
        }
    }
}

// Define the preview provider
struct SessionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of CallSession for the preview
        let sampleSession = CallSession(id: "Sample_id", name: "Sample Session", participants: 1)
        
        // Create an instance of CallSessionManager for the preview
        let callSessionManager = CallSessionManager()

        // Pass both the sample session and callSessionManager to SessionDetailView
        SessionDetailView(session: sampleSession, callSessionManager: callSessionManager)
    }
}

