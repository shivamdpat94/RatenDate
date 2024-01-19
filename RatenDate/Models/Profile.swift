import Foundation
import SwiftUI
import CoreLocation
import UIKit
import Firebase

struct Profile: Identifiable {
    
    let id: String
    var rating: Double
    var timesRated: Double
    var rateSum: Double
    var email: String
    var location: CLLocation
    var age: Int
    var gender: String
    var ethnicity: String
    var bio: String
    var traits: [String]
    var lookingFor: String
    var firstName: String
    var photoURLs: [String]
    var images: [UIImage] = []  // To store the fetched images
    var password: String
    var phoneNumber: String
    var dob: Date
    var height: String
    var wantKids: String
    var hasKids: String
    var politics: String
    var religion: String
    var languages: [String]
    var occupation: String
    var educationLevel: String
    var areaOfStudy: String
    var alcohol: String
    var cigerettes: String
    var drugs: String
    var interests: [String]
    var likeSet: Set<String>
    var matchSet: Set<String>
    
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? UUID().uuidString
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        if let location = dictionary["location"] as? GeoPoint {
            self.location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        } else {
            self.location = CLLocation()
        }
        self.age = dictionary["age"] as? Int ?? 0
        self.gender = dictionary["gender"] as? String ?? ""
        self.ethnicity = dictionary["ethnicity"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        self.traits = dictionary["traits"] as? [String] ?? []
        self.lookingFor = dictionary["lookingFor"] as? String ?? ""
        self.rateSum = dictionary["rateSum"] as? Double ?? 0.0
        self.timesRated = dictionary["timesRated"] as? Double ?? 0.0
        self.rating = dictionary["rating"] as? Double ?? 0.0
        self.photoURLs = dictionary["photoURLs"] as? [String] ?? []

        self.password = dictionary["password"] as? String ?? ""
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        if let dobString = dictionary["dob"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            self.dob = dateFormatter.date(from: dobString) ?? Date()
        } else {
            self.dob = Date()
        }
        self.height = dictionary["height"] as? String ?? ""
        self.wantKids = dictionary["wantKids"] as? String ?? ""
        self.hasKids = dictionary["hasKids"] as? String ?? ""
        self.politics = dictionary["politics"] as? String ?? ""
        self.religion = dictionary["religion"] as? String ?? ""
        self.languages = dictionary["languages"] as? [String] ?? []
        self.occupation = dictionary["occupation"] as? String ?? ""
        self.educationLevel = dictionary["educationLevel"] as? String ?? ""
        self.areaOfStudy = dictionary["areaOfStudy"] as? String ?? ""
        self.alcohol = dictionary["alcohol"] as? String ?? ""
        self.cigerettes = dictionary["cigerettes"] as? String ?? ""
        self.drugs = dictionary["drugs"] as? String ?? ""
        self.interests = dictionary["interests"] as? [String] ?? []
        self.images = []
        self.likeSet = Set(dictionary["likeSet"] as? [String] ?? [])
        self.matchSet = Set(dictionary["matchSet"] as? [String] ?? [])
    }
}

// Extension to convert Profile to a dictionary
extension Profile {
    var dictionary: [String: Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dobString = dateFormatter.string(from: self.dob)

        return [
            "firstName": firstName,
            "id": id,
            "rating": rating,
            "email": email,
            "timesRated": timesRated,
            "rateSum": rateSum,
            "age": age,
            "gender": gender,
            "ethnicity": ethnicity,
            "bio": bio,
            "traits": traits,
            "lookingFor": lookingFor,
            "photoURLs": photoURLs,
            "location": GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
            "password": password,
            "phoneNumber": phoneNumber,
            "dob": dobString,
            "height": height,
            "wantKids": wantKids,
            "hasKids": hasKids,
            "politics": politics,
            "religion": religion,
            "languages": languages,
            "occupation": occupation,
            "educationLevel": educationLevel,
            "areaOfStudy": areaOfStudy,
            "alcohol": alcohol,
            "cigerettes": cigerettes,
            "drugs": drugs,
            "interests": interests,
            "likeSet": Array(likeSet),
            "matchSet": Array(matchSet)
        ]
    }
}


// SwiftUI Preview for the Profile
struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        let dummyData: [String: Any] = [
            "id": UUID().uuidString,
            "firstName": "Leslie",
            "email": "email@gmail.com",
            "location": GeoPoint(latitude: 40.7128, longitude: -74.0060),
            "age": 28,
            "gender": "Female",
            "ethnicity": "Hispanic",
            "bio": "Love hiking and the outdoors. Looking for someone to share adventures with.",
            "traits": ["Hiking", "Photography", "Cooking"],
            "lookingFor": "A serious relationship",
            "rateSum": 0.0,
            "timesRated": 0.0,
            "rating": 0.0,
            "photoURLs": [String](),
            "password": "password123",
            "phoneNumber": "1234567890",
            "dob": "01/01/1995",
            "height": "5'6\"",
            "wantKids": "Yes",
            "hasKids": "No",
            "politics": "Liberal",
            "religion": "Atheist",
            "languages": ["English", "Spanish"],
            "occupation": "Developer",
            "educationLevel": "Bachelor's",
            "areaOfStudy": "Computer Science",
            "alcohol": "Occasionally",
            "cigerettes": "Never",
            "drugs": "Never",
            "interests": ["Technology", "Gaming"]
        ]

        let dummyProfile = Profile(dictionary: dummyData)
        return VStack(alignment: .leading) {
            Text("Name: \(dummyProfile.firstName)")
            Text("Age: \(dummyProfile.age)")
            Text("Bio: \(dummyProfile.bio)")
        }
        .padding()
    }
}
