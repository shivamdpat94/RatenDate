//
//  ImageManipulation.swift
//  RatenDate
//
//  Created by Mitchell Buff on 1/20/24.
//

import Foundation
import UIKit

struct ImageManipulation {

    func compressImage(_ originalImage: UIImage, toMaxFileSize maxFileSize: Int, withCompressionQuality quality: CGFloat = 1.0) -> UIImage? {
        guard let compressedData = originalImage.jpegData(compressionQuality: quality) else { return nil }
        
        if compressedData.count < maxFileSize {
            return UIImage(data: compressedData)
        } else {
            let newQuality = quality * 0.9 // Reduce quality by 10%
            return compressImage(originalImage, toMaxFileSize: maxFileSize, withCompressionQuality: newQuality)
        }
    }

}

extension UIImage {
//    func resized(withPercentage percentage: CGFloat) -> UIImage? {
//        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
//        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
//        defer { UIGraphicsEndImageContext() }
//        draw(in: CGRect(origin: .zero, size: canvasSize))
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }
    func resized(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
