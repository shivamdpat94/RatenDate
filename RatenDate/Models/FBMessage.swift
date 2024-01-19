//
//  Message.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/18/24.
//

import Foundation
import FirebaseFirestore // Import Firestore to use Timestamp

struct FBMessage: Codable {
    var text: String
    var timestamp: Timestamp
    var firstName: String
    var email: String

    // Initialize the struct with all properties
    init(text: String, timestamp: Timestamp = Timestamp(date: Date()), firstName: String, email: String) {
        self.text = text
        self.timestamp = timestamp
        self.firstName = firstName
        self.email = email
    }

    // Helper to convert to a dictionary, useful for uploading to Firestore
    var dictionary: [String: Any] {
        return [
            "text": text,
            "timestamp": timestamp,
            "firstName": firstName,
            "email": email
        ]
    }
}
