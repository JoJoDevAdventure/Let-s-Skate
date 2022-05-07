//
//  NewPostViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 06/05/2022.
//

import Foundation
import UIKit

protocol NewPostViewModelOutPut: AnyObject {
    func setUsername(username: String)
    func showError(error: Error)
    func postUploadedWithSuccess()
    func postHasNoPhotos()
}

class NewPostViewModel {
    
    weak var output: NewPostViewModelOutPut?
    let postsService: NewPostService
    
    init(postsService: NewPostService) {
        self.postsService = postsService
    }
    
    func getCurrentUser() {
        postsService.getCurrentUserNickname {[weak self] results in
            switch results {
            case .success(let username):
                self?.output?.setUsername(username: username)
            case .failure(let error):
                self?.output?.showError(error: error)
            }
        }
    }
    
    func uploadUserPost(post: UIImageView, bio: String) {
        
        guard let post = post.image else {
            ImageErrorAnimations().animateImage(imageView: post)
            output?.postHasNoPhotos()
            return
        }
        postsService.uploadNewPost(post: post, bio: bio) {[weak self] results in
            switch results {
            case .failure(let error):
                self?.output?.showError(error: error)
            case .success(()) :
                self?.output?.postUploadedWithSuccess()
            }
        }
    }
    
}
