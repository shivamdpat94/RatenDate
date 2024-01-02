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
    @State private var selectedImages: [Int: UIImage] = [:]  // To hold the selected images with their index
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
                            uploadPhoto(index: index, image: image)
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

    func uploadPhoto(index: Int, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        let storage = Storage.storage()
        let storageRef = storage.reference()
        let photoRef = storageRef.child("photos/\(profileID)/photo\(index).jpg")

        // Upload the image to Firebase Storage
        let uploadTask = photoRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }

            // Get the download URL
            photoRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Handle the error
                    print(error?.localizedDescription ?? "Unknown error")
                    return
                }

                // Append the URL string to your photoURLs array
                DispatchQueue.main.async {
                    self.photoURLs.append(downloadURL.absoluteString)
                    self.uploadCount += 1  // Increment the count for each successful upload
                    
                    // Check if all photos are uploaded or attempted
                    if self.uploadCount == 6 {
                        onPhotosUploaded()  // Call the completion handler after all 6 uploads are attempted
                    }
                }
            }
        }
    }
}

struct PhotoUploadView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoUploadView(
            photoURLs: .constant([]),
            onPhotosUploaded: {
                // Define what should happen when photos are uploaded here, if anything.
            },
            profileID: "dummyProfileID"  // Provide a dummy profileID for preview purposes
        )
    }
}
