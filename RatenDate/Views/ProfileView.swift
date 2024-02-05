import SwiftUI
import CoreLocation

struct ProfileView: View {
    var profile: Profile
    @StateObject private var cityFetcher = CityFetcher()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                // Carousel for photos
                TabView {
                    ForEach(profile.photoURLs, id: \.self) { photoURL in
                        Group {
                            if let image = ImageCache.shared.getImage(forKey: photoURL) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width, height: 300)
                                    .cornerRadius(20)
                            } else {
                                AsyncImage(url: URL(string: photoURL)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image.resizable()
                                             .aspectRatio(contentMode: .fill)
                                    case .empty:
                                        ProgressView()
                                    case .failure(_):
                                        Image(systemName: "photo")
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width, height: 300)
                                .cornerRadius(20)
                            }
                        }
                        .clipped()
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 300)

                // Display other profile attributes with modified styles
                HStack {
                    Text("Name: \(profile.firstName)")
                        .font(.title)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Text("Age: \(profile.age)")
                        .font(.title)
                        .foregroundColor(.black)
                        .frame(alignment: .trailing)
                }

                Group {
                    Text("Location: \(cityFetcher.cityName)")
                    Text("Bio: \(profile.bio)")
                    Text("Ethnicity: \(profile.ethnicity)")
                    Text("Gender: \(profile.gender)")
                    Text("Traits: \(profile.traits.joined(separator: ", "))")
                    Text("Looking For: \(profile.lookingFor)")
                    Text("Email: \(profile.email)")
                }
                .foregroundColor(.black)
            }
            .padding()
            .background(Color.blue.opacity(0.2)) // Semi-transparent blue background
            .cornerRadius(20) // Rounded corners for the frame
            .padding() // Outer padding to create space around the frame
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("bg_FLAKES_BLUE")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            // Trigger city name fetch when the view appears
            cityFetcher.fetchCityName(from: profile.location)
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleLocation = CLLocation(latitude: 40.7128, longitude: -74.0060)
        let sampleProfileData: [String: Any] = [
            "age": 24,
            "bio": "Sample bio...",
            "ethnicity": "Sample Ethnicity",
            "firstName": "John",
            "gender": "Male",
            "id": "sample-id",
            "traits": ["Music", "Art"],
            "lookingFor": "Friendship",
            // Array of photo URLs from Unsplash
            "photoURLs": [
                "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                "https://images.unsplash.com/photo-1551782450-a2132b4ba21d?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                "https://images.unsplash.com/photo-1504868584819-f8e8b4b6d7e3?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                "https://images.unsplash.com/photo-1517520287167-4bbf64a00d66?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                "https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
            ],
            "rateSum": 10,
            "rating": 5,
            "timesRated": 2,
            "email": "John@aol.com",
            "location": sampleLocation
        ]

        let sampleProfile = Profile(dictionary: sampleProfileData)
        return ProfileView(profile: sampleProfile)
    }
}

