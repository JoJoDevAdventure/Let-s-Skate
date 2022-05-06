//
//  NewPostViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 06/05/2022.
//

import Foundation

class NewPostViewModel {
    
    let postsService: NewPostService
    
    init(postsService: NewPostService) {
        self.postsService = postsService
    }
    
    func getCurrentUser() {
        postsService.getCurrentUserUsername { results in
            switch results {
            case .success(let username): break
            case .failure(_): break
            }
        }
    }
    
}
