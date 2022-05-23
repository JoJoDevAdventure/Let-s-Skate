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
    func likeUnlikePost(post: Post, completion: @escaping(Result<Post,Error>) -> Void)
}

protocol ProfilePostsService {
    func deletePost(post: Post, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchUserPosts(uid: String, completion: @escaping (Result<User,Error>) -> Void)
}

protocol ExplorePostService {
    func fetchAllPosts(completion: @escaping (Result<[Post], Error>) -> Void)
}

class PostsManager: NewPostService, FeedPostsService, ProfilePostsService, ExplorePostService {
    
    let imageUploaderService: ImageUploader
    
    init(imageUploaderService: ImageUploader) {
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
                    
                    if var post = try? document.data(as: Post.self) {
                        self.storeRef.collection("users")
                            .document(post.uid)
                            .getDocument { snapshot , error in
                                guard let snapshot = snapshot else {
                                    completion(.failure(error!))
                                    return
                                }
                                guard let user = try? snapshot.data(as: User.self) else { return }
                                post.user = user
                                self.checkLikedPost(post: post) { results in
                                    switch results {
                                    case .failure(let error):
                                        completion(.failure(error))
                                    case .success(let post) :
                                        posts.append(post)
                                        completion(.success(posts))
                                    }
                                }
                                
                                
                            }
                    }
                }
            }
        
        // fetch all posts for a us
    }
    
    func fetchUserPosts(uid: String, completion: @escaping (Result<User,Error>) -> Void) {
        storeRef.collection("posts").whereField("uid", isEqualTo: uid).getDocuments {[weak self] snapshot, error in
            if error != nil {
                completion(.failure(error!))
            }
            guard let documents = snapshot?.documents else { return }
            self?.storeRef.collection("users")
                .document(uid)
                .getDocument { snapshot , error in
                    guard let snapshot = snapshot else {
                        completion(.failure(error!))
                        return
                    }
                    guard var user = try? snapshot.data(as: User.self) else { return }
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
    
    func deletePost(post: Post, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let postId = post.id else { return  }
        storeRef.collection("posts").document(postId).delete { error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(()))
        }
    }
    
    func likeUnlikePost(post: Post, completion: @escaping(Result<Post,Error>) -> Void) {
        guard let currentUserUid = currentUserUid else { return }
        guard let postId = post.id else { return }
        guard var liked = post.liked else { return }
        if liked {
            storeRef.collection("users").document(currentUserUid).collection("likes").document(postId).delete()
            var fpost = post
            liked.toggle()
            fpost.liked = liked
            completion(.success(fpost))
        } else {
            storeRef.collection("users").document(currentUserUid).collection("likes").document(postId).setData([:])
            var fpost = post
            liked.toggle()
            fpost.liked = liked
            completion(.success(fpost))
        }
    }
    
    func checkLikedPost(post: Post, completion: @escaping (Result<Post, Error>) -> Void) {
        guard let currentUid = currentUserUid else { return }
        guard let postId = post.id else { return }
        var liked = false
        storeRef.collection("users").document(currentUid).collection("likes").getDocuments { snapshot, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let documents = snapshot?.documents else { return }
            documents.forEach { document in
                if document.documentID == postId {
                    liked = true
                }
            }
            var fpost = post
            fpost.liked = liked
            completion(.success(fpost))
        }
    }

}
