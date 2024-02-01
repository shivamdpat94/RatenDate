import Foundation
import WebRTC
import Combine

class WebRTCManager: NSObject, ObservableObject {
    // WebRTC components
    private var peerConnectionFactory: RTCPeerConnectionFactory
    private var peerConnection: RTCPeerConnection?
    private var localVideoTrack: RTCVideoTrack?
    private var remoteVideoTrack: RTCVideoTrack?
    private var userEmail: String

    // Use Published property wrapper for properties that should update the UI
    @Published var isCallActive: Bool = false

    // Delegate for handling remote stream
    weak var delegate: WebRTCManagerDelegate?

    init(userEmail: String) {
        self.userEmail = userEmail
        let encoderFactory = RTCDefaultVideoEncoderFactory()
        let decoderFactory = RTCDefaultVideoDecoderFactory()
        self.peerConnectionFactory = RTCPeerConnectionFactory(encoderFactory: encoderFactory, decoderFactory: decoderFactory)

        super.init()
        
        self.initializePeerConnection()
    }
    private func initializePeerConnection() {
        let configuration = RTCConfiguration()
        configuration.iceServers = [RTCIceServer(urlStrings: ["stun:stun.l.google.com:19302"])]
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: ["DtlsSrtpKeyAgreement": kRTCMediaConstraintsValueTrue])
        peerConnection = peerConnectionFactory.peerConnection(with: configuration, constraints: constraints, delegate: self)
    }

    func createOffer(completion: @escaping (RTCSessionDescription?) -> Void) {
        peerConnection?.offer(for: RTCMediaConstraints(mandatoryConstraints: ["OfferToReceiveAudio": "true", "OfferToReceiveVideo": "true"], optionalConstraints: nil), completionHandler: { (sdp, error) in
            guard let offer = sdp else {
                print("Error creating offer: \(String(describing: error))")
                completion(nil)
                return
            }
            self.peerConnection?.setLocalDescription(offer, completionHandler: { (error) in
                if let error = error {
                    print("Error setting local description: \(error)")
                    completion(nil)
                } else {
                    completion(offer)
                }
            })
        })
    }

    func createAnswer(completion: @escaping (RTCSessionDescription?) -> Void) {
        peerConnection?.answer(for: RTCMediaConstraints(mandatoryConstraints: ["OfferToReceiveAudio": "true", "OfferToReceiveVideo": "true"], optionalConstraints: nil), completionHandler: { (sdp, error) in
            guard let answer = sdp else {
                print("Error creating answer: \(String(describing: error))")
                completion(nil)
                return
            }
            self.peerConnection?.setLocalDescription(answer, completionHandler: { (error) in
                if let error = error {
                    print("Error setting local description: \(error)")
                    completion(nil)
                } else {
                    completion(answer)
                }
            })
        })
    }

    func handleRemoteCandidate(_ candidate: RTCIceCandidate) {
        peerConnection?.add(candidate)
    }
    func initiateCall() {
        // Create an offer if you are the caller
        createOffer { [weak self] offer in
            guard let offer = offer else { return }
            self?.peerConnection?.setLocalDescription(offer, completionHandler: { error in
                if let error = error {
                    print("Error setting local description: \(error)")
                    return
                }
                // Send this offer to the remote peer via your signaling mechanism (e.g., Firestore)
                // This part depends on how you've implemented signaling
            })
        }
    }

    
    func setupLocalMedia() {
        // Create local video and audio tracks
        let videoSource = peerConnectionFactory.videoSource()
        localVideoTrack = peerConnectionFactory.videoTrack(with: videoSource, trackId: "video0")
        let audioTrack = peerConnectionFactory.audioTrack(withTrackId: "audio0")

        // Add these tracks to the media stream
        let stream = peerConnectionFactory.mediaStream(withStreamId: "stream0")
        stream.addVideoTrack(localVideoTrack!)
        stream.addAudioTrack(audioTrack)

        // Add this stream to the peer connection
        peerConnection?.add(stream)
    }

    // More functions as needed for WebRTC setup
}

// MARK: - RTCPeerConnectionDelegate
extension WebRTCManager: RTCPeerConnectionDelegate {
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        // Handle added stream
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
        // Handle removed stream
    }

    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        // Handle negotiation
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCPeerConnectionState) {
        // Handle peer connection state change
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        // Handle ICE connection state change
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        // Handle ICE gathering state change
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        // Handle new ICE candidate
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        // Handle removed ICE candidates
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        // Handle opened data channel
    }

}

// MARK: - WebRTCManagerDelegate
protocol WebRTCManagerDelegate: AnyObject {
    func didReceiveRemoteVideoTrack(track: RTCVideoTrack?)
}
