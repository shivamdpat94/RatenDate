//
//  RetrievedProfile.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/3/24.
//
import Foundation
import SwiftUI
import CoreLocation
import UIKit



struct RetrievedProfile {
    var age: Int
    var bio: String
    var ethnicity: String
    var firstName: String
    var gender: String
    var id: String
    var imageNames: [String]
    var traits: [String]
    var lookingFor: String
    var photoURLs: [String]
    var rateSum: Int
    var rating: Int
    var timesRated: Int
    var email: String
    
    
    // Initialize with individual parameters
    init(age: Int, bio: String, ethnicity: String, firstName: String, gender: String, id: String, imageNames: [String], traits: [String], lookingFor: String, photoURLs: [String], rateSum: Int, rating: Int, timesRated: Int, email: String) {
        self.age = age
        self.bio = bio
        self.ethnicity = ethnicity
        self.firstName = firstName
        self.gender = gender
        self.id = id
        self.imageNames = imageNames
        self.traits = traits
        self.lookingFor = lookingFor
        self.photoURLs = photoURLs
        self.rateSum = rateSum
        self.rating = rating
        self.timesRated = timesRated
        self.email = email
    }

    // Initialize from a dictionary
    init(dictionary: [String: Any]) {
        self.age = dictionary["age"] as? Int ?? 0
        self.bio = dictionary["bio"] as? String ?? ""
        self.ethnicity = dictionary["ethnicity"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? "Unknown"
        self.gender = dictionary["gender"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? UUID().uuidString
        self.imageNames = dictionary["imageNames"] as? [String] ?? []
        self.traits = dictionary["traits"] as? [String] ?? []
        self.lookingFor = dictionary["lookingFor"] as? String ?? ""
        self.photoURLs = dictionary["photoURLs"] as? [String] ?? []
        self.rateSum = dictionary["rateSum"] as? Int ?? 0
        self.rating = dictionary["rating"] as? Int ?? 0
        self.timesRated = dictionary["timesRated"] as? Int ?? 0
        self.email = dictionary["email"] as? String ?? ""
    }
}
