//
//  File.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 29/04/2022.
//

import Foundation
import FirebaseStorage
import UIKit

protocol ImageUploader {
    func uploadBannerImage(image: UIImage, completion: @escaping(Result<String, StorageError>) -> Void)
}

class StorageManager: ImageUploader {
    
    
    private let profileRef = Storage.storage().reference(withPath: "/profile_image/")
    
    init() {
    }
    
    func uploadBannerImage(image: UIImage, completion: @escaping(Result<String, StorageError>) -> Void)  {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        let fileName = NSUUID().uuidString
        let bannersRef = Storage.storage().reference(withPath: "/banner_image/\(fileName)")
        let metadata = StorageMetadata()
        
        bannersRef.putData(imageData, metadata: metadata) { _, error in
            if let error = error {
                StorageError.allCases.forEach { storageError in
                    if error as! StorageError == storageError { completion(.failure(storageError)) }
                }
            }
            
            //no errors
            bannersRef.downloadURL { imageURL, error in
                guard let imageUrl = imageURL?.absoluteString else { return }
                completion(.success(imageUrl))
            }
        }
        
    }
    
    func uploadProfileImage(image: UIImage, completion: @escaping(Result<String, StorageError>) -> Void)  {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        let fileName = NSUUID().uuidString
        let bannersRef = Storage.storage().reference(withPath: "/profile_image/\(fileName)")
        let metadata = StorageMetadata()
        
        bannersRef.putData(imageData, metadata: metadata) { _, error in
            if let error = error {
                StorageError.allCases.forEach { storageError in
                    if error as! StorageError == storageError { completion(.failure(storageError)) }
                }
            }
            
            //no errors
            bannersRef.downloadURL { imageURL, error in
                guard let imageUrl = imageURL?.absoluteString else { return }
                completion(.success(imageUrl))
            }
        }
        
    }

}

