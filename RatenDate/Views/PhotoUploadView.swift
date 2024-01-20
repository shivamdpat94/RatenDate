//
//  PhotoUploadView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/1/24.
//

// PhotoUploadView.swift

import SwiftUI
import FirebaseStorage  // Ensure you've added Firebase Storage to your project
import SotoRekognition
import SotoS3

struct PhotoUploadView: View {
    @State private var aws: AWS?
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
                uploadAndCheckImages()
                onPhotosUploaded()
            }
        }
    }
    private func uploadAndCheckImages() {
        aws = AWS()  // Initialize AWS instance
// Iterate through selected images
        var count = 0
        var upto = selectedImages.count
        for (index, image) in selectedImages {
            // Convert UIImage to Data for uploading
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { continue }
            let key = "photos/\(UUID().uuidString)/photo\(index).jpg"  // Generate a unique key for S3

            // Upload the image to S3
            aws.uploadImageToS3(bucket: "lemonlime-rekognition-input-bucket", key: key, imageData: imageData).whenComplete { result in
                switch result {
                    case .success:
                        // Check the image for moderation labels
                        aws.detectModerationLabels(bucket: "lemonlime-rekognition-input-bucket", key: key).whenComplete { result in
                            switch result {
                                case .success(let response):
                                    if let labels = response.moderationLabels, labels.isEmpty {
                                        // Image passed moderation
                                        print("Image \(index) is OK")
                                    } else {
                                        // Image contains moderation labels
                                        print("Image \(index) is lewd")
                                    }
                                case .failure(let error):
                                    // Handle error in moderation label detection
                                    print("Error in detecting moderation labels: \(error)")
                            }
                            count = count + 1
                            if count == upto
                            {
                                aws.clientShutdown()
                            }
                        }
                    case .failure(let error):
                        // Handle error in uploading to S3
                        print("Error in uploading image to S3: \(error)")
                }
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
