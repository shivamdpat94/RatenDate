import SwiftUI

struct ChatBubbleView: View {
    let message: Message

    var body: some View {
        // Define custom colors using the hexadecimal values
        let customGreen = Color(red: 166 / 255, green: 242 / 255, blue: 108 / 255)
        let customGray = Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255)
        
        VStack(alignment: message.isCurrentUser ? .trailing : .leading) {
            HStack {
                if message.isCurrentUser {
                    Spacer()
                }
                
                Text(message.text)
                    .padding(8)
                    .foregroundColor(.black) // Text color is now black for all messages
                    .background(message.isCurrentUser ? customGreen : customGray)
                    .cornerRadius(12)
                    .shadow(color: .gray, radius: 3, x: 0, y: 3) // Shadow with offset
                
                if !message.isCurrentUser {
                    Spacer()
                }
            }
            .padding(message.isCurrentUser ? .leading : .trailing, 60)
            .padding(.horizontal, 20)
        }
        .transition(.slide)
        .animation(.default)
    }
}


struct ChatBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview for a message from the current user
            ChatBubbleView(
                message: Message(id: "1", text: "Hi there!", isCurrentUser: true, date: Date())
            )

            // Preview for a message from the match
            ChatBubbleView(
                message: Message(id: "2", text: "Hello!", isCurrentUser: false, date: Date())
            )
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
