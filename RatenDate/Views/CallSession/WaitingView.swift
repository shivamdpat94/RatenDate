//
//  WaitingView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/25/24.
//

import SwiftUI

struct WaitingView: View {
    @Environment(\.presentationMode) var presentationMode
    var session: CallSession
    var sessionId: String?
    @ObservedObject var callSessionManager: CallSessionManager

    var body: some View {
        VStack {
            Text("Waiting for your partner")
            Button("Cancel") {
                callSessionManager.cancelSession(sessionId: session.id)
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

//#Preview {
//    WaitingView()
//}
