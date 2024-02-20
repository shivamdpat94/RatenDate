import SwiftUI

struct LoadingView: View {
    var body: some View {
        // Use the image as the background
        Image("splash")
            .resizable() // Make the image resizable
            .aspectRatio(contentMode: .fill) // Fill the entire view
            .edgesIgnoringSafeArea(.all) // Extend the background image to the screen edges
    }
}

// Preview provider, if needed
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
