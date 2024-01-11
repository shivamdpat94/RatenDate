//
//  testview.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/10/24.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        VStack {
            // Title
            Text("LEMONLIME")
                .font(.largeTitle)
                .foregroundColor(.green)
            
            // Cards area
            VStack {
                HStack {
                    CardView(score: 6.9)
                    CardView(score: 6.9)
                    CardView(score: 6.9)
                }
                HStack {
                    CardView(score: 6.9)
                    CardView(score: 6.9)
                    CardView(score: 6.9)
                }
                // Add more HStacks if there are more rows of cards
            }
            
            Spacer()
            
            // Bottom navigation bar
            HStack {
                Image(systemName: "lemon.fill") // replace with your custom icon
                Image(systemName: "face.dashed") // replace with your custom icon
                Image(systemName: "heart.fill") // replace with your custom icon
                Image(systemName: "bubble.left") // replace with your custom icon
                Image(systemName: "person.fill") // replace with your custom icon
            }
            .imageScale(.large)
            .padding()
        }
    }
}

struct CardView: View {
    var score: Double // Assuming you want to pass a dynamic score for each card

    var body: some View {
        ZStack(alignment: .topTrailing) { // Align the score to the top right
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray) // Change to lime green color
                .frame(width: 100, height: 150)

            Text(String(format: "%.1f", score)) // Format the double to one decimal place
                .foregroundColor(.green) // Assuming you want the score text in white
                .font(.caption)
                .padding([.top, .trailing], 5) // Add padding to position the score inside the card's corner
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
