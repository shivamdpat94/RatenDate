import SwiftUI
import Firebase

struct FindCallView: View {
    @EnvironmentObject var sessionManager: UserSessionManager
    @State private var isLookingForCall = false
    @State private var wasLookingForCallBeforeBackground = false // New state variable
    @State private var timerHasElapsed = false
    @State private var reactivationTimer: Timer?

    var body: some View {
        Button(action: toggleLookingForCall) {
            Text(isLookingForCall ? "Cancel Call" : "Find a Call")
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            wasLookingForCallBeforeBackground = isLookingForCall // Update state when going to background
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
                // Reset matched user's profile
                db.collection("profiles").document(matchedEmail).updateData(["isLookingForCall": false])
            }

            // Remove current user
            userDocRef.delete()
            // Reset current user's profile
            db.collection("profiles").document(email).updateData(["isLookingForCall": false])
        }
    }

    
    
    
    private func toggleLookingForCall() {
        if isLookingForCall {
            // Immediately set isLookingForCall to false when cancelling
            isLookingForCall = false
            cancelCall()
        } else {
            // Immediately set isLookingForCall to true when starting to look for a call
            isLookingForCall = true
            updateCallStatusInFirestore()
        }
    }


    private func updateCallStatusInFirestore() {
        guard let email = sessionManager.email else { return }
        let db = Firestore.firestore()

        let userDocRef = db.collection("profiles").document(email)
        let callWaitingDocRef = db.collection("CallWaiting").document(email)

        userDocRef.updateData(["isLookingForCall": isLookingForCall]) { error in
            if let error = error {
                print("Error updating user profile: \(error)")
            }
        }

        if isLookingForCall {
            callWaitingDocRef.setData(["email": email]) { error in
                if let error = error {
                    print("Error adding to CallWaiting: \(error)")
                }
            }
        } else {
            callWaitingDocRef.delete() { error in
                if let error = error {
                    print("Error removing from CallWaiting: \(error)")
                }
            }
        }
    }
}

struct FindCallView_Previews: PreviewProvider {
    static var previews: some View {
        FindCallView().environmentObject(UserSessionManager())
    }
}
