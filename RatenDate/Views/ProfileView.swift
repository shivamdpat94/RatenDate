//
//  ProfileView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/2/24.
//




import SwiftUI
import CoreLocation

struct ProfileView: View {
    var profileID: String
    @State private var profile: Profile?
    @State private var images: [UIImage]

    // Existing initializer, ensuring it allows injecting profile and images.
    init(profileID: String, profile: Profile? = nil, images: [UIImage] = []) {
        self.profileID = profileID
        self._profile = State(initialValue: profile)
        self._images = State(initialValue: images)
    }

    var body: some View {
        ScrollView {
            VStack {
                // Display the images
                ForEach(images, id: \.self) { img in
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }

                // Display the profile info
                if let profile = profile {
                    Text("Name: \(profile.firstName)")
                    Text("Age: \(profile.age)")
                    Text("Bio: \(profile.bio)")
                    Text("Rating: \(profile.rating, specifier: "%.2f")")
                    // Add other profile fields here.
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a stubbed profile with local asset image names
        let stubbedProfile = Profile(
            imageNames: ["Cat1", "Cat2"],
            location: CLLocation(latitude: 37.7749, longitude: -122.4194),
            age: 28,
            id: "dummyID",
            gender: "Non-binary",
            ethnicity: "Mixed",
            firstName: "Alex",
            bio: "Enjoys long walks and good books.",
            interests: ["Books", "Walking"],
            lookingFor: "Friendship",
            photoURLs: []  // No need for URLs when using local assets
        )

        // Load the stubbed images from the assets
        let stubbedImage1 = UIImage(named: "Cat1") ?? UIImage()
        let stubbedImage2 = UIImage(named: "Cat2") ?? UIImage()

        // Pass the stubbed data directly to the ProfileView
        return ProfileView(
            profileID: "dummyID",
            profile: stubbedProfile,
            images: [stubbedImage1, stubbedImage2]  // Pass an array of stubbed images
        )
    }
}


