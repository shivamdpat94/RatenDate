import SwiftUI

struct CallScreenView: View {
    @EnvironmentObject var webRTCManager: WebRTCManager

    var body: some View {
        VStack {
            if webRTCManager.isCallActive {
                // Display the call interface
            } else {
                Text("Waiting for call to connect...")
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                webRTCManager.setupLocalMedia()
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

