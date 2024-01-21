import UIKit

class ImageCache {
    static let shared = ImageCache()
    private init() {}

    var cache: [String: UIImage] = [:]

    func image(forKey key: String) -> UIImage? {
        return cache[key]
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache[key] = image
    }
}
