//
//  Posts Mabager.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 06/05/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import FirebaseAuth
import UIKit

protocol NewPostService {
    func getCurrentUserNickname(completion: @escaping (Result<String, Error>) -> Void )
    func uploadNewPost(post: UIImage, bio: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class PostsManager: NewPostService {
    
    let imageUploaderService: ImageUploader
    
    init(imageUploaderService: ImageUploader) {
        self.imageUploaderService = imageUploaderService
    }
    
    let storeRef = Firestore.firestore()
    
    let currentUserUid = Auth.auth().currentUser?.uid
    
    
    func getCurrentUserNickname(completion: @escaping (Result<String, Error>) -> Void ){
        
        guard let uid = currentUserUid else {
            return }
        storeRef.collection("users").document(uid).getDocument { snapShot, error in
            guard error == nil else{
                completion(.failure(error!))
                return
            }
            guard let user = try? snapShot?.data(as: User.self) else { return }
            completion(.success(user.nickname))
        }
    }
    
    func uploadNewPost(post: UIImage, bio: String, completion: @escaping (Result<Void, Error>) -> Void) {
        imageUploaderService.uploadNewPostImage(image: post) {[weak self] results in
            //upload the image
            switch results {
            case .failure(let error) :
                completion(.failure(error))
            case .success(let imageUrl):
                //add the post to posts collection
                guard let uid = self?.currentUserUid else { return }
                let data = [
                    "uid" : uid,
                    "postUrl" : imageUrl,
                    "bio" : bio,
                    "timestamp":Timestamp(date: Date())] as [String : Any]
                var postRef: DocumentReference? = nil
                postRef = self?.storeRef.collection("posts").addDocument(data: data, completion: { error in
                    if error != nil {
                        completion(.failure(error!))
                    }
                    self?.storeRef.collection("users").document(uid).collection("user-post").document(postRef!.documentID).setData([:], completion: { error in
                        if error != nil {
                            completion(.failure(error!))
                        }
                        completion(.success(()))
                    })
                })
                //add post to the user account
                
                
            }
        }
    }
}
