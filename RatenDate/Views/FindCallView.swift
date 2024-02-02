import SwiftUI
import Firebase

struct FindCallView: View {
    @EnvironmentObject var sessionManager: UserSessionManager
    @EnvironmentObject var webRTCManager: WebRTCManager
    @State private var isLookingForCall = false
    @State private var isMatched = false
    @State private var wasLookingForCallBeforeBackground = false
    @State private var timerHasElapsed = false
    @State private var reactivationTimer: Timer?

    var body: some View {
        VStack {
            Button(action: toggleLookingForCall) {
                Text(isLookingForCall ? "Cancel Call" : "Find a Call")
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                wasLookingForCallBeforeBackground = isLookingForCall
                if isLookingForCall {
                    setCallStatusInactive()
                    startReactivationTimer()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                reactivationTimer?.invalidate()
                if !isLookingForCall && wasLookingForCallBeforeBackground && !timerHasElapsed {
                    toggleLookingForCall()
                }
                timerHasElapsed = false
            }

            if isMatched {
                if let userEmail = sessionManager.email {
                    CallScreenView()
                        .environmentObject(webRTCManager)
                } else {
                    Text("User email not available")
                }
            }
        }
        .onAppear {
            listenForMatch()
        }
    }

    private func listenForMatch() {
        guard let email = sessionManager.email else { return }
        let db = Firestore.firestore()
        db.collection("CallWaiting").document(email)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("Error fetching document: \(error.localizedDescription)")
                    return
                }

                guard let document = documentSnapshot, document.exists, let matchedEmail = document.data()?["matchedEmail"] as? String else {
                    print("No match found or document does not exist.")
                    return
                }

                print("Match found with \(matchedEmail)")
                self.isMatched = true // Trigger navigation to CallScreenView

                self.createCallDocumentAndInitiateOffer(with: email, matchedEmail: matchedEmail)
            }
    }

    private func createCallDocumentAndInitiateOffer(with email: String, matchedEmail: String) {
        FirebaseService.shared.createCallDocument(forUser: email, matchedUserEmail: matchedEmail) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let callId):
                    // Now that you have a callId, you can initiate the offer
                    self.webRTCManager.generateAndUploadOffer(callId: callId)
                case .failure(let error):
                    print("Failed to create call document: \(error.localizedDescription)")
                }
            }
        }
    }

    private func setCallStatusInactive() {
        isLookingForCall = false
        updateCallStatusInFirestore()
    }

    private func startReactivationTimer() {
        timerHasElapsed = false
        reactivationTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            timerHasElapsed = true
        }
    }

    private func cancelCall() {
        guard let email = sessionManager.email else { return }
        let db = Firestore.firestore()

        let userDocRef = db.collection("CallWaiting").document(email)
        userDocRef.getDocument { document, error in
            if let document = document, document.exists,
               let matchedEmail = document.data()?["matchedEmail"] as? String {
                // Remove matched user as well
                let matchedUserDocRef = db.collection("CallWaiting").document(matchedEmail)
                matchedUserDocRef.delete()
                db.collection("profiles").document(matchedEmail).updateData(["isLookingForCall": false])
            }

            userDocRef.delete()
            db.collection("profiles").document(email).updateData(["isLookingForCall": false])
        }
    }

    private func toggleLookingForCall() {
        isLookingForCall.toggle()
        if isLookingForCall {
            updateCallStatusInFirestore()
        } else {
            cancelCall()
        }
    }

    private func updateCallStatusInFirestore() {
        guard let email = sessionManager.email else { return }
        let db = Firestore.firestore()

        let userDocRef = db.collection("profiles").document(email)
        let callWaitingDocRef = db.collection("CallWaiting").document(email)

        userDocRef.updateData(["isLookingForCall": isLookingForCall])
        if isLookingForCall {
            callWaitingDocRef.setData(["email": email])
        } else {
            callWaitingDocRef.delete()
        }
    }
}

struct FindCallView_Previews: PreviewProvider {
    static var previews: some View {
        // Assuming "dummy@example.com" as a placeholder email address for preview purposes
        FindCallView().environmentObject(UserSessionManager()).environmentObject(WebRTCManager(userEmail: "dummy@example.com"))
    }
}
