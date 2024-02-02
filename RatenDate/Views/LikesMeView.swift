//
//  LikesMeView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/8/24.
//

import SwiftUI

struct LikesMeView: View {
    @ObservedObject var viewModel = LikesMeViewModel()

    var body: some View {
        ZStack {
            // Background image
            Image("bg FLAKES")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer(minLength: 80) // Spacer added to push down the banner

                // Banner with shadow
                HStack {
                    Button(action: {
                        // Action for back button
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Text("Likes Me")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        // Action for settings button
                    }) {
                        Image("gear")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .shadow(color: .gray, radius: 5, x: 0, y: 5)

                // ScrollView for user profiles
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(viewModel.userProfiles, id: \.email) { profile in
                            LikesMeUserView(userProfile: profile)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

// Preview
struct LikesMeView_Previews: PreviewProvider {
    static var previews: some View {
        LikesMeView()
    }
}
