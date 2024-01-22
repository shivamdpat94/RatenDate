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
    let aws = AWS()  // Create an instance of your AWS struct
    let imageManipulator = ImageManipulation()
    @Binding var photoURLs: [String]  // This expects a Binding array of strings for URLs
    @State private var showingImagePicker = false
    @State private var selectedImageIndex: Int?  // To know which image slot the user is updating
    @Binding var selectedImages: [Int: UIImage]
    @State private var uploadCount = 0  // To track the number of successful uploads

    var onPhotosUploaded: () -> Void  // Closure to call when photos are uploaded and the user proceeds

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
        // Iterate through selected images
        
        var count = 0
        let upto = selectedImages.count
        for (index, OGimage) in selectedImages {
            // Convert UIImage to Data for uploading
            
            var image = OGimage // Creating a mutable image
            image = image.resized(percentage: 0.35)! // Making the image 50% smaller
            let compressedData = image.jpegData(compressionQuality: 0.001) // Compressing the image as much as possible
            
            guard let finalImageData = compressedData else { continue }
            let key = "photos/\(UUID().uuidString)/photo\(index).jpg"  // Generate a unique key for S3

            // Upload the image to S3
            aws.uploadImageToS3(bucket: "lemonlime-rekognition-input-bucket", key: key, imageData: finalImageData).whenComplete { result in
                switch result {
                    case .success:
                        // Check the image for moderation labels
                        aws.detectModerationLabels(bucket: "lemonlime-rekognition-input-bucket", key: key).whenComplete { result in
                            switch result {
                            case .success(let response):
                                if let labels = response.moderationLabels {
                                    // Check if any label corresponds to nudity
                                    let containsNudity = labels.contains { label in
                                        label.name?.lowercased().contains("nudity") ?? false
                                    }

                                    if containsNudity {
                                        // Image is classified as lewd due to nudity
                                        print("Image \(index) is lewd")
                                    } else {
                                        // Image passed moderation (no nudity detected)
                                        print("Image \(index) is OK")
                                    }
                                } else {
                                    // No labels detected, image is OK
                                    print("Image \(index) is OK")
                                }
                            case .failure(let error):
                                // Handle error in moderation label detection
                                print("Error in detecting moderation labels: \(error)")
                            }
                            count += 1
                            if(count == upto){
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
            }
        )
    }
}
