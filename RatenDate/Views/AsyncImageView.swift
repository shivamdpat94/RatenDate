//
//  AsyncImageView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/21/24.
//

import SwiftUI

struct AsyncImageView: View {
    @State private var image: UIImage?
    let imageURL: String

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Rectangle()
                    .fill(Color.gray)
            }
        }
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        guard let url = URL(string: imageURL) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}


//#Preview {
//    AsyncImageView()
//}
