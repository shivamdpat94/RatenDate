//
//  CardView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/1/24.
//

import SwiftUI

struct CardView: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill) // Fill the entire card area
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .clipped() // Ensure the image doesn't exceed the bounds of the card
            .cornerRadius(20)
    }
}
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(imageName: "Dog1")
    }
}

