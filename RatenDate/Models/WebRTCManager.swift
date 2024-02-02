import Foundation
import WebRTC

class WebRTCManager: NSObject, ObservableObject {
    private var peerConnectionFactory: RTCPeerConnectionFactory
    private var peerConnection: RTCPeerConnection?
    @Published var currentCallId: String?
    @Published var isCallActive: Bool = false
    var userEmail: String // Add this line to store the user's email

    init(userEmail: String) {
        self.userEmail = userEmail
        let encoderFactory = RTCDefaultVideoEncoderFactory()
        let decoderFactory = RTCDefaultVideoDecoderFactory()
        self.peerConnectionFactory = RTCPeerConnectionFactory(encoderFactory: encoderFactory, decoderFactory: decoderFactory)
        super.init()
        initializePeerConnection()
    }
    
    
    
    func handleReceivedAnswer(_ answer: RTCSessionDescription) {
        peerConnection?.setRemoteDescription(answer, completionHandler: { [weak self] error in
            if let error = error {
                print("Error setting remote description (answer): \(error)")
            } else {
                self?.isCallActive = true
                print("Answer set successfully, call is active.")
            }
        })
    }
    
    
    func generateAndUploadOffer(callId: String) {
        createOffer { [weak self] sdpOffer in
            guard let sdpOffer = sdpOffer else { return }
            // Assuming you have a method in FirebaseService to upload the offer
            FirebaseService.shared.uploadWebRTCOffer(offer: sdpOffer, forCall: callId) { success in
                if success {
                    print("Offer successfully uploaded.")
                } else {
                    print("Failed to upload offer.")
                }
            }
        }
    }

    // Add this method to listen for offers specifically for the callee
    func listenForOffer() {
        guard let callId = currentCallId else { return }
        FirebaseService.shared.listenForOffer(callId: callId) { [weak self] offer in
            guard let self = self, let offer = offer else { return }
            self.peerConnection?.setRemoteDescription(offer, completionHandler: { error in
                if let error = error {
                    print("Error setting remote description: \(error)")
                    return
                }
                // After setting the remote description, create and upload an answer
                self.createAnswer { answer in
                    guard let answer = answer else { return }
                    FirebaseService.shared.uploadWebRTCAnswer(answer: answer, forCall: callId) { success in
                        if success {
                            print("Answer uploaded successfully.")
                        } else {
                            print("Failed to upload answer.")
                        }
                    }
                }
            })
        }
    }

    // Call this method right after initializing the peer connection
    func startListeningForRemoteICECandidates() {
        guard let callId = currentCallId else { return }
        FirebaseService.shared.listenForRemoteICECandidates(callId: callId) { [weak self] candidate in
            guard let self = self, let candidate = candidate else { return }
            self.peerConnection?.add(candidate)
        }
    }

    func listenForAnswer() {
        guard let callId = currentCallId else { return }
        FirebaseService.shared.listenForAnswer(callId: callId) { [weak self] answer in
            guard let self = self, let answer = answer else { return }
            self.peerConnection?.setRemoteDescription(answer, completionHandler: { error in
                if let error = error {
                    print("Error setting remote description (answer): \(error)")
                    return
                }
                // The call can now proceed with the established connection
                self.isCallActive = true
            })
        }
    }

    func setupLocalMedia() {
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        let audioSource = peerConnectionFactory.audioSource(with: constraints)
        let audioTrack = peerConnectionFactory.audioTrack(with: audioSource, trackId: "audio0")
        
        // Add this track to the peer connection
        peerConnection?.add(audioTrack, streamIds: ["stream0"])
    }

    func initiateCall() {
        peerConnection?.offer(for: RTCMediaConstraints(mandatoryConstraints: ["OfferToReceiveAudio": "true"], optionalConstraints: nil), completionHandler: { [weak self] sdp, error in
            guard let self = self, let sdp = sdp, error == nil else { return }
            
            self.peerConnection?.setLocalDescription(sdp, completionHandler: { error in
                guard error == nil else { return }
                
                // Signal this offer SDP to the remote peer via your signaling server or mechanism
                // This might involve calling a method on your FirebaseService to upload the offer to Firestore
                FirebaseService.shared.uploadWebRTCOffer(offer: sdp, forCall: self.currentCallId ?? "", completion: { success in
                    if success {
                        print("Offer uploaded successfully")
                    } else {
                        print("Failed to upload offer")
                    }
                })
            })
        })
    }

    
    private func initializePeerConnection() {
        let configuration = RTCConfiguration()
        configuration.iceServers = [RTCIceServer(urlStrings: ["stun:stun.l.google.com:19302"])]
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: ["DtlsSrtpKeyAgreement": kRTCMediaConstraintsValueTrue])
        peerConnection = peerConnectionFactory.peerConnection(with: configuration, constraints: constraints, delegate: self)
    }
    
    func createOffer(completion: @escaping (RTCSessionDescription?) -> Void) {
        peerConnection?.offer(for: RTCMediaConstraints(mandatoryConstraints: ["OfferToReceiveAudio": "true"], optionalConstraints: nil), completionHandler: { sdp, error in
            guard let sdp = sdp, error == nil else {
                completion(nil)
                return
            }
            self.peerConnection?.setLocalDescription(sdp, completionHandler: { error in
                guard error == nil else {
                    completion(nil)
                    return
                }
                completion(sdp)
            })
        })
    }
    
    func createAnswer(completion: @escaping (RTCSessionDescription?) -> Void) {
        peerConnection?.answer(for: RTCMediaConstraints(mandatoryConstraints: ["OfferToReceiveAudio": "true"], optionalConstraints: nil), completionHandler: { sdp, error in
            guard let sdp = sdp, error == nil else {
                completion(nil)
                return
            }
            self.peerConnection?.setLocalDescription(sdp, completionHandler: { error in
                guard error == nil else {
                    completion(nil)
                    return
                }
                completion(sdp)
            })
        })
    }
    
    func handleRemoteCandidate(_ candidate: RTCIceCandidate) {
        peerConnection?.add(candidate)
    }
}







// MARK: - RTCPeerConnectionDelegate
extension WebRTCManager: RTCPeerConnectionDelegate {
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCPeerConnectionState) {
        DispatchQueue.main.async { [weak self] in
            switch newState {
            case .connected:
                self?.isCallActive = true
                print("WebRTC connection established.")
                // Additional actions when the call is connected, like notifying the UI.
            case .failed, .disconnected:
                self?.isCallActive = false
                print("WebRTC connection failed or disconnected.")
                // Handle reconnection or call termination.
            default:
                print("WebRTC connection state changed: \(newState)")
            }
        }
    }


    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        guard let currentCallId = self.currentCallId else { return }
        FirebaseService.shared.uploadWebRTCIceCandidate(candidate: candidate, forCall: currentCallId) { success in
            if success {
                print("Local ICE candidate uploaded successfully.")
            } else {
                print("Failed to upload local ICE candidate.")
            }
        }
    }

    
    // Implement other delegate methods as needed.
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCSignalingState) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {}
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {}
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {}
}
