//
//  AWS.swift
//  RatenDate
//
//  Created by Mitchell Buff on 1/20/24.
//

import Foundation
import SotoCore
import SotoRekognition
import SotoS3

class AWS {
    let accessKeyId: String
    let secretAccessKey: String
    let client: AWSClient
    let rekognition: Rekognition
    let s3: S3

    init() {
        // Initialize with environment variables
        guard let accessKey = ProcessInfo.processInfo.environment["ACCESS_KEY"],
              let secretKey = ProcessInfo.processInfo.environment["SECRET_ACCESS_KEY"] else {
            fatalError("AWS credentials are not set in environment variables")
        }

        self.accessKeyId = accessKey
        self.secretAccessKey = secretKey

        // Initialize AWS Client
        self.client = AWSClient(
            credentialProvider: .static(accessKeyId: accessKeyId, secretAccessKey: secretAccessKey),
            httpClientProvider: .createNew
        )
        self.rekognition = Rekognition(client: client, region: .useast1)  // Specify your region
        self.s3 = S3(client: client, region: .useast1)
    }

    // Function to upload an image to S3
    func uploadImageToS3(bucket: String, key: String, imageData: Data) -> EventLoopFuture<S3.PutObjectOutput> {
        let putRequest = S3.PutObjectRequest(body: .data(imageData), bucket: bucket, key: key)
        return s3.putObject(putRequest)
    }

    // Function to perform image moderation using Rekognition
    func detectModerationLabels(bucket: String, key: String) -> EventLoopFuture<Rekognition.DetectModerationLabelsResponse> {
        let image = Rekognition.Image(s3Object: Rekognition.S3Object(bucket: bucket, name: key))
        let request = Rekognition.DetectModerationLabelsRequest(image: image)
        return rekognition.detectModerationLabels(request)
    }
    
    func detectNumberOfFaces(bucket: String, key: String) -> EventLoopFuture<Int> {
        let image = Rekognition.Image(s3Object: Rekognition.S3Object(bucket: bucket, name: key))
        let request = Rekognition.DetectFacesRequest(attributes: [.all], image: image)

        return rekognition.detectFaces(request).map { response in
            print(response.faceDetails?.count ?? 0, "HERE WE GO")
            return response.faceDetails?.count ?? 0
        }
    }
    
    func compareFaces(sourceBucket: String, sourceKey: String, targetBucket: String, targetKey: String) -> EventLoopFuture<Bool> {
        let sourceImage = Rekognition.Image(s3Object: Rekognition.S3Object(bucket: sourceBucket, name: sourceKey))
        let targetImage = Rekognition.Image(s3Object: Rekognition.S3Object(bucket: targetBucket, name: targetKey))

        let request = Rekognition.CompareFacesRequest(similarityThreshold: 80, sourceImage: sourceImage, targetImage: targetImage) // Adjust similarity threshold as needed

        return rekognition.compareFaces(request).map { response in
            guard let faceMatches = response.faceMatches else {
                print("No face matches found.")
                return false
            }

            for match in faceMatches {
                if match.similarity ?? 0 >= 80 { // Check if the similarity is above the threshold
                    print("Match found with similarity: \(match.similarity ?? 0)%")
                    return true
                }
            }

            print("No matching faces with sufficient similarity.")
            return false
        }
    }
    
    func clientShutdown(){
        do {
            try self.client.syncShutdown()
            print("AWS client shut down successfully.")
        } catch {
            print("Error shutting down AWS client: \(error)")
        }
    }

//    deinit {
//        // Attempt to shut down the client gracefully
//        do {
//            try client.syncShutdown()
//            print("AWS client shut down successfully.")
//        } catch {
//            print("Error shutting down AWS client: \(error)")
//        }
//    }
}
