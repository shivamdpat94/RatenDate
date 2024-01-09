//
//  ProfileView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/3/24.
//

import SwiftUI

struct ProfileView: View {
    var profile: RetrievedProfile

    var body: some View {
        // Construct your view for each profile
        VStack {
            Text(profile.firstName)
            // Add more UI elements as needed
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand the VStack to fill the screen
    }
}

// PreviewProvider for ProfileView
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample profile to display in the preview
        let sampleProfile = RetrievedProfile(
            age: 24,
            bio: "Sample bio...",
            ethnicity: "Sample Ethnicity",
            firstName: "John",
            gender: "Male",
            id: "sample-id",
            imageNames: ["image1", "image2"],
            interests: ["Music", "Art"],
            lookingFor: "Friendship",
            photoURLs: ["https://example.com/photo1.jpg"],
            rateSum: 10,
            rating: 5,
            timesRated: 2
        )

        // Pass the sample profile to the ProfileView
        ProfileView(profile: sampleProfile)
    }
}
