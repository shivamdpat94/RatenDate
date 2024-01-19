import Foundation

import SotoCore
import SotoRekognition
import SotoS3

struct AWS {
    let accessKeyId: String
    let secretAccessKey: String
    let client: AWSClient
    let rekognition: Rekognition
    let s3: S3

    init() {
        // Initialize with environment variables
        guard let accessKey = ProcessInfo.processInfo.environment["AWS_ACCESS_KEY_ID"],
              let secretKey = ProcessInfo.processInfo.environment["AWS_SECRET_ACCESS_KEY"] else {
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
    
}
