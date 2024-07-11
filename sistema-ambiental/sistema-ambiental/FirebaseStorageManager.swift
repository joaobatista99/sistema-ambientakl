//
//  FirebaseStorageManager.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 02/12/23.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()
    
    func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }
        
        let storageRef = Storage.storage().reference()
        let imageName = UUID().uuidString
        let imageRef = storageRef.child("images/\(imageName).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                imageRef.downloadURL { (url, error) in
                    if let downloadURL = url {
                        completion(.success(downloadURL))
                    } else {
                        completion(.failure(error ?? NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve download URL"])))
                    }

                }
            }
            
        }
        
        uploadTask.observe(.progress) { snapshot in
            print(snapshot.progress)
        }
        
        uploadTask.observe(.success) { snapshot in
            print("suceeso no upload")
        }
        
        uploadTask.observe(.failure) { snapshot in
            print(snapshot.error)
        }
    }
}
