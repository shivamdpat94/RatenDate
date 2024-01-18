import SwiftUI

struct TraitsAndInterestsView: View {
    @Binding var traits: [String]
    @Binding var interests: [String]
    var onComplete: () -> Void
    
    let traitOptions = [
        "Adventurous", "Ambitious", "Artistic", "Caring", "Charismatic",
        "Compassionate", "Confident", "Creative", "Curious", "Dependable",
        "Determined", "Diligent", "Empathetic", "Energetic", "Enthusiastic",
        "Friendly", "Funny", "Generous", "Genuine", "Hardworking",
        "Honest", "Humble", "Imaginative", "Independent", "Intelligent",
        "Kind", "Logical", "Loyal", "Mature", "Motivated",
        "Optimistic", "Organized", "Outgoing", "Passionate", "Patient",
        "Perceptive", "Persistent", "Philosophical", "Practical", "Proactive",
        "Reliable", "Respectful", "Responsible", "Romantic", "Self-disciplined",
        "Sensitive", "Sociable", "Spontaneous", "Strategic", "Sympathetic",
        "Thoughtful", "Tolerant", "Trustworthy", "Understanding", "Versatile",
        "Visionary", "Warm", "Wise", "Witty", "Zealous"
    ]
    
    let interestOptions = [
        "Acting", "Archery", "Astronomy", "Baking", "Blogging",
        "Board games", "Camping", "Chess", "Coding", "Cooking",
        "Crafting", "Creative writing", "Cycling", "Dancing", "Digital art",
        "Drawing", "Drone piloting", "Fashion design", "Film-making", "Fishing",
        "Fitness", "Gardening", "Graphic design", "Hiking", "Homebrewing",
        "Jogging", "Knitting", "Martial arts", "Meditation", "Mountain biking",
        "Music production", "Painting", "Photography", "Pilates", "Podcasting",
        "Poetry", "Pottery", "Programming", "Reading", "Robotics",
        "Rock climbing", "Role-playing games", "Running", "Sailing", "Scuba diving",
        "Sculpting", "Sewing", "Skateboarding", "Skiing", "Skydiving",
        "Snorkeling", "Snowboarding", "Surfing", "Swimming", "Table tennis",
        "Traveling", "Video gaming", "Volunteering", "Weightlifting", "Woodworking",
        "Yoga", "Zumba"
    ]
    
    
    var body: some View {
        VStack {
            Text("Select Your Traits")
            ScrollView {
                VStack {
                    ForEach(traitOptions, id: \.self) { trait in
                        MultipleSelectionRow2(title: trait, isSelected: traits.contains(trait)) {
                            if traits.contains(trait) {
                                traits.removeAll { $0 == trait }
                            } else {
                                traits.append(trait)
                            }
                        }
                    }
                }
                .padding()
            }
            Text("Select Your Interests")
            
            ScrollView {
                VStack {
                    ForEach(interestOptions, id: \.self) { trait in
                        MultipleSelectionRow2(title: trait, isSelected: interests.contains(trait)) {
                            if interests.contains(trait) {
                                interests.removeAll { $0 == trait }
                            } else {
                                interests.append(trait)
                            }
                        }
                    }
                }
                .padding()
            }
            .frame(maxHeight: 300) // Adjust this value to control the height of the selection area
            Button("Complete Sign Up") {
                print("Complete Sign UP")
                onComplete()
                // Add other UI elements here if needed
                
            }
        }
    }
    
    struct MultipleSelectionRow2: View {
        var title: String
        var isSelected: Bool
        var action: () -> Void
        
        var body: some View {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
            .onTapGesture {
                action()
            }
            .padding(.vertical, 4)
        }
    }
    
    struct TraitsAndInterestsView_Previews: PreviewProvider {
        @State static var dummyTraits = [String]()
        @State static var dummyInterests = [String]()
        
        static var previews: some View {
            TraitsAndInterestsView(
                traits: $dummyTraits,
                interests: $dummyInterests,
                onComplete: {}
                
            )
        }
    }
}
