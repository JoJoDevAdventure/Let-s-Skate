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
    
    init(imageUploaderService: ImageUploader ,userService: FeedUserService) {
        self.imageUploaderService = imageUploaderService
    }
    
    let storeRef = Firestore.firestore()
    
    let currentUserUid = Auth.auth().currentUser?.uid
    
    // get current user nickname
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
    
    //upload new post to database
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
    
    // get all posts for feed
    func fetchAllPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
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
                var posts : [Post] = []
                documents.forEach { document in
                    if let post = try? document.data(as: Post.self) {
                        posts.append(post)
                    }
                }
                
            var finalPosts: [Post] = []
                posts.forEach {[weak self] post in
                    self?.userService.fetchUser(withUid: post.uid) { results in
                        switch results {
                        case .failure(let error):
                            completion(.failure(error))
                        case .success(let user):
                            var Npost = post
                            Npost.user = user
                            finalPosts.append(Npost)
                            completion(.success(finalPosts))
                        }
                        
                    }
                }
                
            }
    }
    
    // fetch all posts for a user
    func fetchUserPosts(uid: String, completion: @escaping (Result<User,Error>) -> Void) {
        storeRef.collection("posts").whereField("uid", isEqualTo: uid).getDocuments {[weak self] snapshot, error in
            if error != nil {
                completion(.failure(error!))
            }
            guard let documents = snapshot?.documents else { return }
            
            self?.userService.fetchUser(withUid: uid) { results in
                switch results {
                case .failure(let error):
                    completion(.failure(error))
                case .success(var user):
                    user.posts = []
                    documents.forEach { document in
                        if let post = try? document.data(as: Post.self) {
                            user.posts!.append(post)
                        }
                    }
                    completion(.success(user))
                }
            }
        }
    }
    
}
