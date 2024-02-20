import SwiftUI
import CoreLocation

struct ProfileView: View {
    var profile: Profile
    @StateObject private var cityFetcher = CityFetcher()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                photoCarousel
                primaryInfo
                basicInfoSection
                professionalInfoSection
                familyGoalsSection
                beliefsSection
                lifestyleChoicesSection
            }
            .padding()
            .background(Color.blue.opacity(0.05))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .padding()
        }
        .background(
            Image("bg FLAKES")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            cityFetcher.fetchCityName(from: profile.location)
        }
    }
    
    
    private func SectionView<Content: View>(title: String, content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Content with the title at the top
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.top) // Padding on top for the title

                content
            }
            .padding() // Padding around the content
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .clipShape(CustomCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 15))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.blue, lineWidth: 1)
            )
        }
    }



    struct CustomCorners: Shape {
        var corners: UIRectCorner
        var radius: CGFloat
        
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }


    private var basicInfoSection: some View {
         SectionView(title: "Basic Info", content: VStack(alignment: .leading, spacing: 5) {
             Text("Ethnicity: \(profile.ethnicity)")
             Text("Gender: \(profile.gender)")
             Text("Height: \(profile.height)")
             Text("Languages: \(profile.languages.joined(separator: ", "))")
         })
     }

     // Professional Information Section
     private var professionalInfoSection: some View {
         SectionView(title: "Professional Info", content: VStack(alignment: .leading, spacing: 5) {
             Text("Occupation: \(profile.occupation)")
             Text("Area of Study: \(profile.areaOfStudy)")
             Text("Education: \(profile.educationLevel)")
         })
     }

     // Family Goals Section
    private var familyGoalsSection: some View {
        SectionView(title: "Family Goals", content: VStack(alignment: .leading, spacing: 5) {
            // Conditional display for Wants Kids
            HStack {
                Image("baby-girl-dress") // Ensure the image is in your asset catalog
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(profile.wantKids == "Yes" ? "Wants children" : "Does not want children")
            }

            // Display for Has Kids
            HStack {
                Image("baby-02") // Reuse the image for visual consistency
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(profile.hasKids == "Yes" ? "Has children" : "Does not have children")            }
            HStack {
                Image("in-love") // Reuse the image for visual consistency
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(profile.lookingFor)
            }
        })
    }

     // Beliefs Section
     private var beliefsSection: some View {
         SectionView(title: "Beliefs", content: VStack(alignment: .leading, spacing: 5) {
             HStack {
                 Image("racing-flag") // Reuse the image for visual consistency
                     .resizable()
                     .scaledToFit()
                     .frame(width: 24, height: 24)
                 Text(profile.politics)
             }
             
             HStack {
                 Image("Frame (1)") // Reuse the image for visual consistency
                     .resizable()
                     .scaledToFit()
                     .frame(width: 24, height: 24)
                 Text(profile.religion)
             }         })
     }

     // Lifestyle Choices Section
     private var lifestyleChoicesSection: some View {
         SectionView(title: "Lifestyle Choices", content: VStack(alignment: .leading, spacing: 5) {
             HStack {
                 Image("mdi-glass-tulip") // Reuse the image for visual consistency
                     .resizable()
                     .scaledToFit()
                     .frame(width: 24, height: 24)
                 Text(profile.alcohol)
             }
             HStack {
                 Image("Frame") // Reuse the image for visual consistency
                     .resizable()
                     .scaledToFit()
                     .frame(width: 24, height: 24)
                 Text(profile.cigerettes)
             }

             HStack {
                 Image("mdi-cannabis") // Reuse the image for visual consistency
                     .resizable()
                     .scaledToFit()
                     .frame(width: 24, height: 24)
                 Text(profile.drugs)
             }           
         })
     }


    private func SectionTable(title: String, content: () -> VStack<TupleView<(Text, Text, Text, Text)>>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            
            content()
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.blue, lineWidth: 1)
                )
        }
    }

    
    
    private var photoCarousel: some View {
        TabView {
            ForEach(profile.photoURLs, id: \.self) { photoURL in
                AsyncImage(url: URL(string: photoURL)) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: UIScreen.main.bounds.width, height: 300)
                .cornerRadius(20)
                .clipped()
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .frame(height: 300)
    }
    
    private var primaryInfo: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Name: \(profile.firstName)")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer() // This pushes the age to the right edge of the screen
                
                Text("Age: \(profile.age)")
                    .font(.headline)
                    .foregroundColor(.black)
            }

            
            Text("Location: \(cityFetcher.cityName)")
                .foregroundColor(.black)
                .padding(.top, 5) // Adjusts the spacing between the HStack and the location text
            Spacer() // This pushes the age to the right edge of the screen

            Text("Bio: \(profile.bio)")
                .foregroundColor(.black)
        }
    }


    
    private var additionalDetails: some View {
        VStack(alignment: .leading) {
            // Any other details not included in groups
            Text("Traits: \(profile.traits.joined(separator: ", "))")
                .foregroundColor(.black)
            Text("Premium Member: \(profile.isPremium ? "Yes" : "No")")
                .foregroundColor(.black)
            // Include other fields as needed
        }
    }
    


    private var contactInformation: some View {
        Group {
            Text("Email: \(profile.email)")
            Text("Phone: \(profile.phoneNumber)")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleLocation = CLLocation(latitude: 37.7749, longitude: -122.4194) // Example location: San Francisco
        let sampleProfileData: [String: Any] = [
            "age": 30,
            "bio": "Passionate about technology and innovation. Love to explore new places and cultures. Enjoy hiking, reading, and photography.",
            "ethnicity": "Asian",
            "firstName": "Alex",
            "gender": "Male",
            "id": "sample-id",
            "traits": ["Creative", "Thoughtful", "Adventurous"],
            "lookingFor": "Someone with a great sense of humor and adventure",
            "photoURLs": [
                "https://images.unsplash.com/photo-1531123897727-8f129e1688ce?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                "https://images.unsplash.com/photo-1520813792240-56fc4a3765a7?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                "https://images.unsplash.com/photo-1503457574462-bd27054394c1?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
            ],
            "rateSum": 45,
            "rating": 4.5,
            "timesRated": 10,
            "email": "alex@example.com",
            "location": sampleLocation,
            "height": "5'11\"",
            "wantKids": "Yes",
            "hasKids": "No",
            "politics": "Moderate",
            "religion": "Agnostic",
            "languages": ["English", "Spanish", "Mandarin"],
            "occupation": "Software Engineer",
            "educationLevel": "Master's Degree",
            "areaOfStudy": "Computer Science",
            "alcohol": "Socially",
            "cigerettes": "Never",
            "drugs": "Never",
            "interests": ["Tech", "Hiking", "Photography", "Reading"],
            "isPremium": true
        ]

        let sampleProfile = Profile(dictionary: sampleProfileData)
        return ProfileView(profile: sampleProfile)
    }
}
