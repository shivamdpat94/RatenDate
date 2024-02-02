//
//  FirebaseService.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/3/24.
//

import Firebase
import FirebaseFirestore
import WebRTC

class FirebaseService {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()

    init() {}
    
    
    
    
    func uploadWebRTCOffer(offer: RTCSessionDescription, forCall callId: String, completion: @escaping (Bool) -> Void) {
        let offerDict: [String: Any] = ["type": "offer", "sdp": offer.sdp]
        db.collection("calls").document(callId).updateData(["offer": offerDict]) { error in
            completion(error == nil)
        }
    }
    
    func uploadWebRTCAnswer(answer: RTCSessionDescription, forCall callId: String, completion: @escaping (Bool) -> Void) {
        let answerDict: [String: Any] = ["type": "answer", "sdp": answer.sdp]
        db.collection("calls").document(callId).updateData(["answer": answerDict]) { error in
            completion(error == nil)
        }
    }
    
    func uploadWebRTCIceCandidate(candidate: RTCIceCandidate, forCall callId: String, completion: @escaping (Bool) -> Void) {
        let candidateDict: [String: Any] = [
            "candidate": candidate.sdp,
            "sdpMid": candidate.sdpMid ?? "",
            "sdpMLineIndex": candidate.sdpMLineIndex
        ]
        db.collection("calls").document(callId).collection("candidates").addDocument(data: candidateDict) { error in
            completion(error == nil)
        }
    }
    
    
    
    // Function to create a new call document for matched users
    func createCallDocument(forUser userEmail: String, matchedUserEmail: String, completion: @escaping (Result<String, Error>) -> Void) {
        let callDocRef = db.collection("calls").document() // Generate a new document reference upfront
        let callDocData: [String: Any] = [
            "participants": [userEmail, matchedUserEmail],
            "timestamp": FieldValue.serverTimestamp(),
            "initiator": userEmail,
            "offer": [:],
            "answer": [:]
        ]

        callDocRef.setData(callDocData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(callDocRef.documentID)) // Use callDocRef.documentID
            }
        }
    }





    
    func listenForAnswer(callId: String, completion: @escaping (RTCSessionDescription?) -> Void) {
        db.collection("calls").document(callId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot, let data = document.data(),
                      let answer = data["answer"] as? [String: Any], let sdp = answer["sdp"] as? String else {
                    completion(nil)
                    return
                }
                let sessionDescription = RTCSessionDescription(type: .answer, sdp: sdp)
                completion(sessionDescription)
            }
    }

    
    
    func listenForOffer(callId: String, completion: @escaping (RTCSessionDescription?) -> Void) {
        db.collection("calls").document(callId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot, let data = document.data(),
                      let offer = data["offer"] as? [String: Any], let sdp = offer["sdp"] as? String else {
                    completion(nil)
                    return
                }
                let sessionDescription = RTCSessionDescription(type: .offer, sdp: sdp)
                completion(sessionDescription)
            }
    }

    // Inside FirebaseService.swift
    func listenForRemoteICECandidates(callId: String, completion: @escaping (RTCIceCandidate?) -> Void) {
        db.collection("calls").document(callId).collection("candidates")
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching remote ICE candidates: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                snapshot.documentChanges.forEach { change in
                    if change.type == .added {
                        let data = change.document.data()
                        guard let sdp = data["candidate"] as? String,
                              let sdpMid = data["sdpMid"] as? String,
                              let sdpMLineIndex = data["sdpMLineIndex"] as? Int32 else { return }
                        let candidate = RTCIceCandidate(sdp: sdp, sdpMLineIndex: sdpMLineIndex, sdpMid: sdpMid)
                        completion(candidate)
                    }
                }
            }
    }



    func fetchProfiles(completion: @escaping ([Profile]) -> Void) {
        db.collection("profiles").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var profiles = [Profile]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let profile = Profile(dictionary: data)
                    profiles.append(profile)
                }
                completion(profiles)
            }
        }
    }
    
    
    func saveProfileToFirebase(profile: Profile, completion: @escaping () -> Void) {
        let db = Firestore.firestore()

        db.collection("profiles").document(profile.email).setData(profile.dictionary) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Profile successfully added!")
                completion()  // Call the completion handler after the profile is successfully added
            }
        }
    }
    
    
    
    func fetchProfile(email: String, completion: @escaping (Profile?) -> Void) {
        db.collection("profiles").document(email).getDocument { (document, error) in
            if let document = document, document.exists {
                let profileData = document.data() ?? [:]
                let profile = Profile(dictionary: profileData)
                completion(profile)
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }

    
    
    
    func updateProfile(profile: Profile, completion: @escaping (Bool) -> Void) {
        db.collection("profiles").document(profile.email).updateData(profile.dictionary) { error in
            if let error = error {
                print("Error updating profile: \(error)")
                completion(false)
            } else {
                print("Profile successfully updated!")
                completion(true)
            }
        }
    }

}



