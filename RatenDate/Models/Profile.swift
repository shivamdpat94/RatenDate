import Foundation
import SwiftUI
import CoreLocation
import UIKit
import Firebase

struct Profile: Identifiable {
    let id: String
    var imageNames: [String]
    var rating: Double
    var timesRated: Double
    var rateSum: Double
    var email: String
    var location: CLLocation
    var age: Int
    var gender: String
    var ethnicity: String
    var bio: String
    var interests: [String]
    var lookingFor: String
    var firstName: String
    var photoURLs: [String]
    var images: [UIImage] = []  // To store the fetched images

    // Adjust the initializer to remove the password parameter
    init(
        imageNames: [String],
        location: CLLocation,
        age: Int,
        id: String,
        email: String,
        gender: String,
        ethnicity: String,
        firstName: String,
        bio: String,
        interests: [String],
        lookingFor: String,
        rateSum: Double = 0.0,
        timesRated: Double = 0.0,
        photoURLs: [String] = []
    ) {
        self.id = id
        self.firstName = firstName
        self.imageNames = imageNames
        self.location = location
        self.email = email
        self.age = age
        self.gender = gender
        self.ethnicity = ethnicity
        self.bio = bio
        self.interests = interests
        self.lookingFor = lookingFor
        self.timesRated = timesRated
        self.rateSum = rateSum
        // Handle the division by zero case
        self.rating = timesRated == 0 ? 0 : rateSum / timesRated
        self.photoURLs = photoURLs
        
    }
}

// Extension to convert Profile to a dictionary - useful if you're creating/updating profile documents in Firestore
extension Profile {
    var dictionary: [String: Any] {
        return [
            "firstName": firstName,
            "id": id,
            "imageNames": imageNames,
            "rating": rating,
            "email" : email,
            "timesRated": timesRated,
            "rateSum": rateSum,
            "age": age,
            "gender": gender,
            "ethnicity": ethnicity,
            "bio": bio,
            "interests": interests,
            "lookingFor": lookingFor,
            "photoURLs": photoURLs,
            "location": GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        ]
    }
}

// SwiftUI Preview for the Profile
struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        // Create a dummy profile with the correct order and naming of parameters
        let dummyProfile = Profile(
            imageNames: ["exampleImage1", "exampleImage2"],
            location: CLLocation(latitude: 40.7128, longitude: -74.0060),
            age: 28,
            id: UUID().uuidString,
            email: "email@gmail.com",
            gender: "Female",
            ethnicity: "Hispanic",
            firstName: "Leslie",
            bio: "Love hiking and the outdoors. Looking for someone to share adventures with.",
            interests: ["Hiking", "Photography", "Cooking"],
            lookingFor: "A serious relationship"
            // rateSum and timesRated will use their default values
        )

        // Create a simple view to display some profile information
        VStack(alignment: .leading) {
            Text("Name: \(dummyProfile.firstName)")
            Text("Age: \(dummyProfile.age)")
            Text("Bio: \(dummyProfile.bio)")
            // Add more details as needed
        }
        .padding()
    }
}
