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
    
    /// get current user nickname
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
    
    /// upload new post to database
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
    
    /// fetch user with uid
    func fetchUser(withUid uid: String) async throws -> User {
        do {
            let document = try await storeRef.collection("users")
                .document(uid)
                .getDocument()
            if let user = try? document.data(as: User.self) {
                return user
            } else {
                throw LoginErrors.FIRAuthErrorCodeInvalidEmail
            }
        } catch {
            throw error
        }
    }
    
    /// get all posts for feed
    func fetchAllPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        Task(priority: .medium) {
            do {
                let snapshot = try await storeRef.collection("posts")
                    .order(by: "timestamp", descending: true)
                    .getDocuments()
                let documents = snapshot.documents
                var posts: [Post] = []
                for document in documents {
                    guard var post = try? document.data(as: Post.self) else { return }
                    let user = try await self.fetchUser(withUid: post.uid)
                    post.user = user
                    post = try await self.checkLikedPost(post: post)
                    posts.append(post)
                }
                completion(.success(posts))
            } catch {
                print(error)
            }
        }
        
    }
    
    /// fetch posts for a user
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
    
    /// delete post from database
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
    
    /// like unlike a post from database
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
    
    /// check if post is liked 
    func checkLikedPost(post: Post) async throws -> Post {
        guard let currentUid = currentUserUid else { throw LoginErrors.FIRAuthErrorCodeWrongPassword }
        guard let postId = post.id else { throw LoginErrors.FIRAuthErrorCodeWrongPassword }
        var liked = false
        do {
            let snapshot = try await storeRef.collection("users").document(currentUid).collection("likes").getDocuments()
            let documents = snapshot.documents
            for document in documents {
                if document.documentID == postId {
                    liked = true
                    var fpost = post
                    fpost.liked = liked
                    return fpost
                }
            }
            var fpost = post
            fpost.liked = liked
            return fpost
        } catch {
            throw LoginErrors.FIRAuthErrorCodeWrongPassword
        }
    }

}
