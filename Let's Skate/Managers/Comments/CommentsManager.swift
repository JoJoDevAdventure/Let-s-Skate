//
//  CommentsManager.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 14/05/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import FirebaseAuth
import UIKit

protocol CommentService {
    func uploadComment(comment: String, post: Post, completion: @escaping (Result<Void,Error>)->Void)
    func deleteComment(comment: Comment, post: Post, completion: @escaping (Result<Void,Error>)->Void)
    func fetchAllCommentForPost(post: Post, completion: @escaping (Result<[Comment],Error>)->Void)
}

class CommentsManager: CommentService {
    
    init() {}
    
    let storeRef = Firestore.firestore()
    
    func uploadComment(comment: String, post: Post, completion: @escaping (Result<Void,Error>)->Void) {
        guard let postId = post.id else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        storeRef.collection("posts").document(postId).collection("post-comments").document().setData([
            "comment": comment,
            "postId": postId,
            "uid": userId,
            "date": Timestamp(date: Date())
        ])
        completion(.success(()))
    }
    
    func deleteComment(comment: Comment, post: Post, completion: @escaping (Result<Void,Error>)->Void) {
        guard let commentID = comment.id else { return }
        guard let postID = post.id else { return }
        storeRef.collection("posts").document(postID).collection("post-comments").document(commentID).delete { error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(()))
        }
    }
    
    func fetchAllCommentForPost(post: Post, completion: @escaping (Result<[Comment],Error>)->Void) {
        guard let postID = post.id else { return }
        var finalComments: [Comment] = []
        storeRef.collection("posts").document(postID).collection("post-comments").getDocuments { snapshot, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let documents = snapshot?.documents else { return  }
            let comments = documents.compactMap({try? $0.data(as: Comment.self)})
            if comments.count == 0 {
                completion(.success(finalComments))
            }
            comments.forEach { comment in
                self.storeRef.collection("users").document(comment.uid).getDocument { snapshot, error in
                    guard let user = try? snapshot?.data(as: User.self) else { return }
                    var fComment = comment
                    fComment.post = post
                    fComment.user = user
                    finalComments.append(fComment)
                    completion(.success(finalComments))
                }
            }
        }
    }
    
}
