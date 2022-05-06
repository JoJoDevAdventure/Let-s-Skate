//
//  NewPostViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 06/05/2022.
//

import Foundation

protocol NewPostViewModelOutPut: AnyObject {
    func setUsername(username: String)
    func showError(error: Error)
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
    
}
