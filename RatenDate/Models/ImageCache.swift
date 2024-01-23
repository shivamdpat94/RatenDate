import UIKit

class ImageCache {
    static let shared = ImageCache()
    private init() {}

    var images: [String: UIImage] = [:]

    // Corrected method signatures
    func getImage(forKey key: String) -> UIImage? {
        return images[key]
    }

    func setImage(_ image: UIImage, forKey key: String) {
        images[key] = image
    }
}
