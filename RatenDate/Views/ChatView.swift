//
//  ChatView.swift
//  RatenDate
//
//  Created by Mitchell Buff on 1/13/24.
//

import SwiftUI
import FirebaseFirestore

struct ChatView: View {
    
    var match: Match
    @State private var newMessageText = ""
    @EnvironmentObject var sessionManager: UserSessionManager
    @State private var messages: [MessageFB] = []
    
    
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func isFirstMessageOfDay(message: MessageFB) -> Bool {
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else {
            return false
        }

        if index == 0 {
            return true
        } else {
            let prevDate = messages[index - 1].timestamp
            let currentDate = message.timestamp
            return !Calendar.current.isDate(prevDate, inSameDayAs: currentDate)
        }
    }

    private func isLastMessageOfDay(message: MessageFB) -> Bool {
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else {
            return false
        }

        if index == messages.count - 1 {
            return true
        } else {
            let currentDate = message.timestamp
            let nextDate = messages[index + 1].timestamp
            return !Calendar.current.isDate(currentDate, inSameDayAs: nextDate)
        }
    }
    
    private func loadMessages() {
        let db = Firestore.firestore()
        db.collection("Chats").document(match.id).collection("Messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No documents in 'Messages'")
                    return
                }
                self.messages = documents.map { queryDocumentSnapshot -> MessageFB in
                    let data = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    let text = data["text"] as? String ?? ""
                    let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    let email = data["email"] as? String ?? ""
                    return MessageFB(id: id, text: text, timestamp: timestamp, email: email)
                }
            }
    }

    
    
    func storeMessageFB(in chatID: String, message: MessageFB) {
        let db = Firestore.firestore()
        let messagesRef = db.collection("Chats").document(chatID).collection("Messages")

        messagesRef.addDocument(data: message.dictionary) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Message successfully stored!")
            }
        }
    }



    var body: some View {
        NavigationView {
            VStack {
                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack(spacing: 4) {
                            ForEach(messages) { message in
                                MessageRowView(
                                    message: message,
                                    isMessageFirstOfDay: isFirstMessageOfDay(message: message),
                                    isMessageLastOfDay: isLastMessageOfDay(message: message)
                                )
                                .id(message.id)
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
                                        Image("bg FLAKES") // Using the image as a background
                                            .resizable() // Make it resizable
                                            .scaledToFill() // Scale the image to fill the view
                                            .opacity(0.2)
                                            .edgesIgnoringSafeArea(.all) // Let the image extend to the edges
                                    )
        }.edgesIgnoringSafeArea(.top)
         .onAppear {
                loadMessages()
            }
    }
    
    func sendMessage() {
        if !newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let newMessage = MessageFB(id: UUID().uuidString, text: newMessageText, email: sessionManager.email!)
            messages.append(newMessage)
            storeMessageFB(in: match.id, message: newMessage)
            newMessageText = ""
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a dummy Match object for the preview
        let dummyMatch = Match(
            id: "dummyChatID",
            name: "Dummy Name",
            image: "dummyImageURL",
            lastMessage: "Hello, this is a dummy message",
            messageDate: Date(),
            matchedUserEmail: "Dummyemail@gmail.com"
        )

        ChatView(match: dummyMatch)
            .environmentObject(UserSessionManager()) // Provide a dummy UserSessionManager if needed
    }
}
