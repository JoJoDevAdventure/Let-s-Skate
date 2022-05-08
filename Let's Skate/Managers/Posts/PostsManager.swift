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

protocol FeedPostsService {
    func fetchAllPosts(completion: @escaping (Result<[Post], Error>) -> Void)
}

protocol ProfilePostsService {
    func fetchUserPosts(uid: String, completion: @escaping (Result<User,Error>) -> Void)
}

class PostsManager: NewPostService, FeedPostsService, ProfilePostsService {
    
    let imageUploaderService: ImageUploader
    let userService: FeedUserService
    
    init(imageUploaderService: ImageUploader ,userService: FeedUserService) {
        self.imageUploaderService = imageUploaderService
        self.userService = userService
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
    
    func fetchAllPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        var posts : [Post] = []
        storeRef.collection("posts")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let FetchingPostError = error {
                    completion(.failure(FetchingPostError))
                }
                guard let documents = snapshot?.documents else {
                    return
                }
                // get array of posts
                documents.forEach { document in
                    guard var post = try? document.data(as: Post.self) else { return }
                    //for each post fetch the user
                    let uid = post.uid
                    self.userService.fetchUser(withUid: uid) { results in
                        switch results {
                        case .success(let user):
                            post.user = user
                            posts.append(post)
                            completion( .success(posts))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            }
        
    }
    
    func fetchUserPosts(uid: String, completion: @escaping (Result<User,Error>) -> Void) {
        storeRef.collection("posts").whereField("uid", isEqualTo: uid).getDocuments { snapshot, error in
            if error != nil {
                completion(.failure(error!))
            }
            guard let documents = snapshot?.documents else { return }
            
            documents.forEach { document in
                guard let post = try? document.data(as: Post.self) else { return }
                //for each post fetch the user
                self.userService.fetchUser(withUid: uid) { results in
                    switch results {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(var user):
                        user.posts?.append(post)
                        completion(.success(user))
                    }
                }
            }
        }
    }
}
