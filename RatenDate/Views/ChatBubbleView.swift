//
//  ChatBubbleView.swift
//  RatenDate
//
//  Created by Mitchell Buff on 1/13/24.
//

import SwiftUI

struct ChatBubbleView: View {
    let message: Message
    
    var body: some View {
        // Define custom colors using the hexadecimal values
        let customGreen = Color(red: 166 / 255, green: 242 / 255, blue: 108 / 255)
        let customGray = Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255)
        
        HStack {
            if message.isCurrentUser {
                Spacer()
            }
            
            Text(message.text)
                .padding(10)
                .foregroundColor(.black) // Text color is now black for all messages
                .background(message.isCurrentUser ? customGreen : customGray)
                .cornerRadius(15)
                .shadow(color: .gray, radius: 3, x: 0, y: 3) // Shadow with offset
            
            if !message.isCurrentUser {
                Spacer()
            }
        }
        .padding(message.isCurrentUser ? .leading : .trailing, 60)
        .padding(.horizontal, 10)
        .transition(.slide)
        .animation(.default)
    }
}
