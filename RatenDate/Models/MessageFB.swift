//
//  Message.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/18/24.
//

import Foundation
import FirebaseFirestore

struct MessageFB: Codable, Equatable, Identifiable {
    
    var id: String
    var text: String
    var timestamp: Date
    var email: String

    // Modified initializer to include 'id'
    init(id: String = UUID().uuidString, text: String, timestamp: Date = Date(), email: String) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
        self.email = email
    }

    // Helper to convert to a dictionary, useful for uploading to Firestore
    var dictionary: [String: Any] {
        return [
            "text": text,
            "timestamp": Timestamp(date: timestamp),  // Convert Date to Firestore Timestamp
            "email": email
        ]
    }
}
