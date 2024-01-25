//
//  MessageRowView.swift
//  RatenDate
//
//  Created by Mitchell Buff on 1/24/24.
//

import SwiftUI


public struct MessageRowView: View {
    let message: MessageFB
    let isMessageFirstOfDay: Bool
    let isMessageLastOfDay: Bool
    @EnvironmentObject var sessionManager: UserSessionManager

    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }

    public var body: some View {
        VStack {
            if isMessageFirstOfDay {
                dateHeaderView
            }
            chatBubbleView
        }
    }

    private var dateHeaderView: some View {
        Text(dateString(from: message.timestamp))
            .font(.caption)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 8)
    }

    private var chatBubbleView: some View {
        ChatBubbleView(message: message, currentUserEmail: sessionManager.email!)
            .padding(.vertical, isMessageLastOfDay ? 8 : 2)
    }
}
