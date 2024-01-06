import SwiftUI
import UIKit

struct LoadingView: View {
    let backgroundColor: Color

    init() {
        // Obtain the color from the top-left pixel
        backgroundColor = Color(uiColor: colorOfTopLeftPixel(imageName: "Loading Screen"))
    }

    var body: some View {
        // Use the background color
        backgroundColor
            .edgesIgnoringSafeArea(.all) // Extend the background color to the screen edges
            .overlay(
                // First layer: Blurred image
                Image("Loading Screen")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(0.8)
                    .blur(radius: 15) // Adjust the radius to increase or decrease the blur
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        // Second layer: Clear, slightly smaller image
                        Image("Loading Screen")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(0.78) // Slightly smaller than the blurred image
                            .edgesIgnoringSafeArea(.all)
                    )
            )
    }
}

func colorOfTopLeftPixel(imageName: String) -> UIColor {
    guard let image = UIImage(named: imageName),
          let cgImage = image.cgImage,
          let provider = cgImage.dataProvider,
          let providerData = provider.data,
          let data = CFDataGetBytePtr(providerData) else {
        return UIColor.white // A default color if the image can't be loaded
    }
    
    let pixelData = data // Assuming the image is not alpha-premultiplied

    let r = pixelData[0]
    let g = pixelData[1]
    let b = pixelData[2]
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
}

// Preview provider, if needed
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
