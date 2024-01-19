import Foundation

import SotoCore
import SotoRekognition

struct AWS {
    let accessKeyId: String
    let secretAccessKey: String
    let client: AWSClient
    let rekognition: Rekognition

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
    }

    func moderateImage(imageData: Data, completion: @escaping (Result<[RekognitionLabel], Error>) -> Void) {
        let request = Rekognition.DetectModerationLabelsRequest(image: .init(bytes: imageData))

        rekognition.detectModerationLabels(request).whenComplete { result in
            switch result {
            case .success(let response):
                completion(.success(response.moderationLabels ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
