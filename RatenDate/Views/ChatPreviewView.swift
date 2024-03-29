//
//  ChatPreviewView.swift
//  RatenDate
//
//  Created by Mitchell Buff on 1/13/24.
//
//MatchPhotoView(match: match, photoURLs: $allPhotoURLs)
//    .frame(width: 50, height: 50) // Adjust the frame size as needed



import SwiftUI

struct ChatPreviewView: View {
    var match: Match
    @Binding var photoURLs: [String: String]

    var body: some View {
        HStack(spacing: 10) {
            MatchPhotoView(match: match, photoURLs: $photoURLs)
                .frame(width: 100, height: 100)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(match.name)
                    .fontWeight(.bold)

                Text(match.lastMessage)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Text(timeAgoSinceDate(match.messageDate))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
    
    func timeAgoSinceDate(_ date: Date, numericDates: Bool = true) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components: DateComponents = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year, .second], from: earliest, to: latest)

        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1) {
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1) {
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1) {
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1) {
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1) {
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1) {
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
}


struct ChatPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample Match object for the preview
        let sampleMatch = Match(
            id: "sampleID",
            name: "Sample Name",
            image: "sampleImage", // Ensure this image is available in your assets
            lastMessage: "Sample last message",
            messageDate: Date(),
            matchedUserEmail: "sample@email.com"
        )
        let dummyPhotoURLs = [
            "Alex@gmail.com": "https://example.com/photo1.jpg",
        ]

        // Return the ChatPreviewView with the sample match
        ChatPreviewView(match: sampleMatch, photoURLs: .constant(dummyPhotoURLs))
            .previewLayout(.sizeThatFits) // Sets the size of the preview
            .padding() // Adds some padding around the preview
    }
}
