//
//  CallSessionManager.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/25/24.
//

import Foundation
import Firebase

class CallSessionManager: ObservableObject {
    @Published var sessions: [CallSession] = []

    init() {
        fetchSessions()
    }

    func fetchSessions() {
        let ref = Database.database().reference(withPath: "sessions")
        ref.observe(.value, with: { snapshot in
            var newSessions: [CallSession] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let session = CallSession(snapshot: snapshot) {
                    newSessions.append(session)
                }
            }
            DispatchQueue.main.async {
                self.sessions = newSessions
            }
        })
    }

    
    
    func cancelSession(sessionId: String) {
        // Reference to the session in the Firebase database
        let sessionRef = Database.database().reference(withPath: "sessions/\(sessionId)")

        // Remove the session from the database
        sessionRef.removeValue { error, _ in
            if let error = error {
                print("Error removing session: \(error.localizedDescription)")
            } else {
                print("Session canceled successfully")
                // Optionally, you might want to update your local sessions array to reflect this change
                if let index = self.sessions.firstIndex(where: { $0.id == sessionId }) {
                    DispatchQueue.main.async {
                        self.sessions.remove(at: index)
                    }
                }
            }
        }
    }

    
    
    
    
    func createSession(name: String, completion: @escaping (String?) -> Void) {
        let ref = Database.database().reference(withPath: "sessions").childByAutoId()
        let session = CallSession(id: ref.key ?? UUID().uuidString, name: name, participants: 0, status: .waiting)
        
        ref.setValue(session.toDictionary()) { error, _ in
            if let error = error {
                print("Error creating session: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(ref.key)
            }
        }
    }



    
    
    func joinSession(sessionId: String) {
        let sessionRef = Database.database().reference(withPath: "sessions/\(sessionId)")

        sessionRef.observeSingleEvent(of: .value, with: { snapshot in
            guard var session = CallSession(snapshot: snapshot) else {
                print("Session not found or data is corrupted")
                return
            }

            // Update session data
            session.participants += 1
            if session.participants >= 2 { // Assuming a session is 'active' when there are 2 or more participants
                session.status = .active
            }

            // Update session in Firebase
            sessionRef.updateChildValues(session.toDictionary()) { error, _ in
                if let error = error {
                    print("Error updating session: \(error.localizedDescription)")
                } else {
                    print("Session joined successfully")
                }
            }
        })
    }

}
