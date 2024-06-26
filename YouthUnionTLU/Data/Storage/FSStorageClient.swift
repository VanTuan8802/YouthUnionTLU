//
//  FSStorageClient.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 16/6/24.
//

import Foundation
import UIKit
import FirebaseFirestoreInternal
import FirebaseStorage

class FSStorageClient: StorageClient {
    static let shared = FSStorageClient()
    
    func uploadImage(image: UIImage, path: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageConversion", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to convert image to data"])))
            return
        }
        
        let storageRef = Storage.storage().reference().child("\(path)/\(UUID().uuidString).jpg")
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let downloadURL = url else {
                    completion(.failure(NSError(domain: "DownloadURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to get download URL"])))
                    return
                }
                
                completion(.success(downloadURL.absoluteString))
            }
        }
    }
}
