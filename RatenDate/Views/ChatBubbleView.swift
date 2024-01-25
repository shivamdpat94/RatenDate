import SwiftUI

struct ChatBubbleView: View {
    let message: MessageFB
    let currentUserEmail: String

    var body: some View {
        // Define custom colors using the hexadecimal values
        let customGreen = Color(red: 166 / 255, green: 242 / 255, blue: 108 / 255)
        let customGray = Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255)
        
        let isCurrentUser = message.email == currentUserEmail

        VStack(alignment: isCurrentUser ? .trailing : .leading) {
            HStack {
                if isCurrentUser {
                    Spacer()
                }
                
                Text(message.text)
                    .padding(8)
                    .foregroundColor(.black)
                    .background(isCurrentUser ? customGreen : customGray)
                    .cornerRadius(12)
                    .shadow(color: .gray, radius: 3, x: 0, y: 3)
                
                if !isCurrentUser {
                    Spacer()
                }
            }
            .padding(isCurrentUser ? .leading : .trailing, 60)
            .padding(.horizontal, 20)
        }
        .transition(.slide)
        .animation(.default)
    }
}



struct ChatBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatBubbleView(
                message: MessageFB(id: "1", text: "Hi there!", timestamp: Date(), email: "currentUser@example.com"),
                currentUserEmail: "currentUser@example.com"
            )

            ChatBubbleView(
                message: MessageFB(id: "2", text: "Hello!", timestamp: Date(), email: "otherUser@example.com"),
                currentUserEmail: "currentUser@example.com"
            )
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

