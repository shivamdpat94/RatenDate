import SwiftUI


struct MatchesView: View {
    
    
    @State private var selectedMatchName: String = ""  // State to keep track of the selected match's name
     @State private var isChatViewActive: Bool = false  // State to control the navigation link

    // Mock data for demonstration
    let topMatches = [
        Match(id: "1", name: "Alex", image: "1024x1024", lastMessage: "Hey there!", messageDate: Date().addingTimeInterval(-86400)),
        Match(id: "2", name: "Sam", image: "1024x1024", lastMessage: "How's it going?", messageDate: Date().addingTimeInterval(-172800)),
        // Add more matches...
    ]

    let chattedMatches = [
        Match(id: "3", name: "Jordan", image: "1024x1024", lastMessage: "Wanna meet up?", messageDate: Date().addingTimeInterval(-3600)),
        Match(id: "4", name: "Taylor", image: "1024x1024", lastMessage: "Loved our chat yesterday", messageDate: Date().addingTimeInterval(-7200)),
        // Add more chatted matches...
    ]

    var body: some View {
        NavigationView {
            VStack {
                TopMatchesView(matches: topMatches)
                    .frame(height: 120)

                Divider()

                List(chattedMatches) { match in
                    NavigationLink(
                        destination: ChatView(matchName: $selectedMatchName),
                        isActive: $isChatViewActive
                    ) {
                        ChatPreviewView(match: match)
                            .onTapGesture {
                                selectedMatchName = match.name
                                isChatViewActive = true
                            }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("LEMONLIME")
        }
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView()
    }
}
