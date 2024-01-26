//
//  SessionListView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/25/24.
//

import SwiftUI

struct SessionListView: View {
    @ObservedObject var callSessionManager = CallSessionManager()
    @State private var showingWaitingView = false
    @State private var newSessionId: String?

    var body: some View {
        NavigationView {
            List {
                ForEach(callSessionManager.sessions) { session in
                    NavigationLink(destination: SessionDetailView(session: session, callSessionManager: callSessionManager)) {
                        Text(session.name)
                    }
                }
            }
            .navigationBarTitle("Sessions")
            .navigationBarItems(trailing: Button("Create") {
                createSession()
            })
//            .background(
//                NavigationLink(destination: WaitingView(sessionId: newSessionId, callSessionManager: callSessionManager), isActive: $showingWaitingView) {
//                    EmptyView()
//                }
//            )
        }
    }

    private func createSession() {
        let newSessionName = "Session\(callSessionManager.sessions.count + 1)"
        callSessionManager.createSession(name: newSessionName) { sessionId in
            DispatchQueue.main.async {
                if let sessionId = sessionId {
                    self.newSessionId = sessionId
                    self.showingWaitingView = true
                }
            }
        }
    }
}


#Preview {
    SessionListView()
}
