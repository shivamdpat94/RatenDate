import Foundation
import FirebaseDatabase // Import FirebaseDatabase

struct CallSession: Identifiable {
    let id: String
    var name: String
    var participants: Int
    var status: SessionStatus

    enum SessionStatus: String {
        case waiting, active
    }

    init(id: String, name: String, participants: Int = 0, status: SessionStatus = .waiting) {
        self.id = id
        self.name = name
        self.participants = participants
        self.status = status
    }

    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: AnyObject],
              let name = value["name"] as? String,
              let participants = value["participants"] as? Int,
              let statusString = value["status"] as? String,
              let status = SessionStatus(rawValue: statusString) else {
            return nil
        }
        self.id = snapshot.key
        self.name = name
        self.participants = participants
        self.status = status
    }

    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "participants": participants,
            "status": status.rawValue
        ]
    }
}
