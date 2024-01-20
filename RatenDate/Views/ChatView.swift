//
//  ChatView.swift
//  RatenDate
//
//  Created by Mitchell Buff on 1/13/24.
//

import SwiftUI

struct ChatView: View {
    @State private var newMessageText = ""
    @State private var messages: [Message] = [
        // Dummy data for testing
        Message(id: UUID().uuidString, text: "Hello!", isCurrentUser: false, date: Date().addingTimeInterval(-86400)),
        Message(id: UUID().uuidString, text: "Hi there!", isCurrentUser: true, date: Date())
    ]
    
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func isFirstMessageOfDay(at index: Int) -> Bool {
        if index == 0 {
            return true
        } else {
            let calendar = Calendar.current
            let prevDate = messages[index - 1].date
            let currentDate = messages[index].date
            return !calendar.isDate(prevDate, inSameDayAs: currentDate)
        }
    }

    private func isLastMessageOfDay(at index: Int) -> Bool {
        if index == messages.count - 1 {
            return true
        } else {
            let calendar = Calendar.current
            let currentDate = messages[index].date
            let nextDate = messages[index + 1].date
            return !calendar.isDate(currentDate, inSameDayAs: nextDate)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack(spacing: 4) {
                            ForEach(messages.indices, id: \.self) { index in
                                if isFirstMessageOfDay(at: index) {
                                    Text(dateString(from: messages[index].date))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding(.top, 8)
                                }
                                
                                ChatBubbleView(message: messages[index])
                                    .padding(.vertical, isLastMessageOfDay(at: index) ? 8 : 2)
                                    .id(messages[index].id)
                            }
                        }
                    }
                    .onChange(of: messages) { _ in
                        if let lastMessage = messages.last {
                            scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                
                HStack {
                    TextField("Message...", text: $newMessageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: CGFloat(30))
                    
                    Button(action: sendMessage) {
                        Text("Send")
                    }
                    .disabled(newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.horizontal)
                }
                .padding()
            }
            .padding(.top, 1) // Small padding to ensure it's below the dynamic island
                        .navigationTitle("LEMONLIME")
                        .navigationBarTitleDisplayMode(.inline)
                        .background(
                                        Image("lemonfinal") // Using the image as a background
                                            .resizable() // Make it resizable
                                            .scaledToFill() // Scale the image to fill the view
                                            .opacity(0.2)
                                            .edgesIgnoringSafeArea(.all) // Let the image extend to the edges
                                    )
        }.edgesIgnoringSafeArea(.top)
    }
    
    func sendMessage() {
        if !newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let newMessage = Message(id: UUID().uuidString, text: newMessageText, isCurrentUser: true, date: Date())
            messages.append(newMessage)
            newMessageText = ""
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
