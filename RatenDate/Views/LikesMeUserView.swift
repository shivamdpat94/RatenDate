import SwiftUI

struct LikesMeUserView: View {
    var userProfile: UserProfile

    var body: some View {
        ZStack(alignment: .bottom) {
            // Display the user's image
            if let photoURL = userProfile.photoURL, let url = URL(string: photoURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray // Placeholder for loading image
                }
                .frame(width: 165, height: 205)
                .cornerRadius(20)
                .shadow(radius: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 2) // Gray border matching cornerRadius
                )
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 165, height: 205)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 2) // Gray border matching cornerRadius
                    )
            }

            // Display the user's name
            Text(userProfile.firstName)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
                .foregroundColor(.white)
                .offset(y: -10)
        }
    }
}

// Preview
//struct LikesMeUserView_Previews: PreviewProvider {
//    static var previews: some View {
//        LikesMeUserView(userProfile: UserProfile(email: "test@example.com", firstName: "Alice", photoURL: "https://example.com/photo.jpg"))
//    }
//}
