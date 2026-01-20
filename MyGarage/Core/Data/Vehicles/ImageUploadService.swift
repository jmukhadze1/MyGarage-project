//
//  ImageUploadService.swift
//  MyGarage
//
//  Created by David on 20.01.26.
//

import UIKit
import FirebaseStorage

final class ImageUploadService {

    private let storage = Storage.storage()

    func uploadVehicleImage(image: UIImage, userId: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(
                domain: "Image",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to convert image"]
            )
        }

        let imageId = UUID().uuidString
        let filePath = "users/\(userId)/vehicles/\(imageId).jpg"
        let reference = storage.reference().child(filePath)

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            reference.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }

        let downloadURL: URL = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<URL, Error>) in
            reference.downloadURL { url, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let url = url {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(throwing: NSError(
                        domain: "Storage",
                        code: 2,
                        userInfo: [NSLocalizedDescriptionKey: "Download URL is nil"]
                    ))
                }
            }
        }

        return downloadURL.absoluteString
    }
}
