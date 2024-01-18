//
//  ProfileView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/3/24.
//

import SwiftUI
import CoreLocation

struct ProfileView: View {
    var profile: Profile

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(profile.photoURLs, id: \.self) { photoURL in
                    AsyncImage(url: URL(string: photoURL)) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fill) // Fill the width of the screen
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: UIScreen.main.bounds.width) // Set the width to the screen's width
                    .clipped() // Clip the overflowing part
                }

                // Display other profile attributes
                Text("Name: \(profile.firstName)")
                Text("Age: \(profile.age)")
                Text("Bio: \(profile.bio)")
                Text("Ethnicity: \(profile.ethnicity)")
                Text("Gender: \(profile.gender)")
                Text("traits: \(profile.traits.joined(separator: ", "))")
                Text("Looking For: \(profile.lookingFor)")
                Text("email: \(profile.email)")
                // Add more attributes as needed
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a dictionary representing the sample profile
        let sampleLocation = CLLocation(latitude: 40.7128, longitude: -74.0060)
        let sampleProfileData: [String: Any] = [
            "age": 24,
            "bio": "Sample bio...",
            "ethnicity": "Sample Ethnicity",
            "firstName": "John",
            "gender": "Male",
            "id": "sample-id",
            "imageNames": ["image1", "image2"],
            "traits": ["Music", "Art"],
            "lookingFor": "Friendship",
            "photoURLs": ["https://example.com/photo1.jpg"],
            "rateSum": 10,
            "rating": 5,
            "timesRated": 2,
            "email": "John@aol.com",
            // Use CLLocation directly for the sample location
            "location": sampleLocation
        ]

        // Initialize the Profile using the dictionary
        let sampleProfile = Profile(dictionary: sampleProfileData)

        // Pass the sample profile to the ProfileView
        ProfileView(profile: sampleProfile)
    }
}

