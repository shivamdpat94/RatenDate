//
//  PhotoUploadView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/1/24.
//

// PhotoUploadView.swift

import SwiftUI
import FirebaseStorage  // Ensure you've added Firebase Storage to your project

struct PhotoUploadView: View {
    @Binding var photoURLs: [String]  // This expects a Binding array of strings for URLs
    @State private var showingImagePicker = false
    @State private var selectedImageIndex: Int?  // To know which image slot the user is updating
    @Binding var selectedImages: [Int: UIImage]
    @State private var uploadCount = 0  // To track the number of successful uploads

    var onPhotosUploaded: () -> Void  // Closure to call when photos are uploaded and the user proceeds
    var profileID: String  // Add this to accept the profile's unique ID

    var body: some View {
        VStack {
            Text("Upload up to 6 photos").padding()

            ForEach(0..<6) { index in
                if let image = selectedImages[index] {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            self.selectedImageIndex = index
                            self.showingImagePicker = true
                        }
                } else {
                    Button(action: {
                        self.selectedImageIndex = index
                        self.showingImagePicker = true
                    }) {
                        Text("Upload Photo \(index + 1)")
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: Binding<UIImage?>(
                    get: { self.selectedImages[self.selectedImageIndex ?? 0] },
                    set: { image in
                        if let image = image, let index = self.selectedImageIndex {
                            // Assign the selected image to the correct index
                            self.selectedImages[index] = image
                        }
                        self.showingImagePicker = false
                    }
                )) {
                    // Handle completion if needed
                }
            }

            Button("Next") {
                onPhotosUploaded()
            }
        }
    }

}

struct PhotoUploadView_Previews: PreviewProvider {
    @State static var dummyPhotoURLs = [String]()  // Dummy state for photo URLs
    @State static var dummySelectedImages = [Int: UIImage]()  // Dummy state for selected images

    static var previews: some View {
        PhotoUploadView(
            photoURLs: $dummyPhotoURLs,  // Pass the dummy binding for photo URLs
            selectedImages: $dummySelectedImages,  // Pass the dummy binding for selected images
            onPhotosUploaded: {
                // Define what should happen when photos are uploaded here, if anything.
            },
            profileID: "dummyProfileID"  // Provide a dummy profileID for preview purposes
        )
    }
}
