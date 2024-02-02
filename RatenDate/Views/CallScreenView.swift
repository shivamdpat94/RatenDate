import SwiftUI

struct CallScreenView: View {
    @EnvironmentObject var webRTCManager: WebRTCManager

    var body: some View {
        VStack {
            if webRTCManager.isCallActive {
                // Active call UI
                Text("Call Connected")
                // Include controls for muting, hanging up, etc.
            } else {
                // Waiting for call to connect UI
                Text("Waiting for call to connect...")
                // Optionally include a cancel button
            }
        }
        .onAppear {
            webRTCManager.setupLocalMedia()
            if let currentCallId = webRTCManager.currentCallId, !currentCallId.isEmpty {
                // Callee logic
                webRTCManager.listenForOffer()
                webRTCManager.startListeningForRemoteICECandidates()
            } else {
                // Caller logic
                webRTCManager.initiateCall()
            }
        }
    }
}

struct CallScreenView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a dummy userEmail for preview purposes
        CallScreenView().environmentObject(WebRTCManager(userEmail: "dummy@example.com"))
    }
}

