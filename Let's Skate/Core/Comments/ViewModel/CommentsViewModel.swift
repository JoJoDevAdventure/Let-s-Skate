//
//  CommentsViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 13/05/2022.
//

import Foundation

protocol CommentsViewModelOutPut : AnyObject {
    func fetchComments(comments: [Comment])
    func showError(error: Error)
}

class CommentsViewModel {
    
    weak var output: CommentsViewModelOutPut?
    let commentSerivce: CommentService
    let post: Post
    
    init(post: Post, commentService: CommentService) {
        self.post = post
        self.commentSerivce = commentService
    }
    
    func uploadComment(comment: String) {
        commentSerivce.uploadComment(comment: comment, post: post) {[weak self] results in
            switch results {
            case .failure(let error):
                self?.output?.showError(error: error)
            case .success(()):
                self?.fetchAllComments()
            }
        }
    }
    
    func fetchAllComments() {
        commentSerivce.fetchAllCommentForPost(post: post) {[weak self] results in
            switch results {
            case .failure(let error) :
                self?.output?.showError(error: error)
            case .success(let comments) :
                self?.output?.fetchComments(comments: comments)
            }
        }
    }
    
    func deletePostAt() {
        
    }
    
}
