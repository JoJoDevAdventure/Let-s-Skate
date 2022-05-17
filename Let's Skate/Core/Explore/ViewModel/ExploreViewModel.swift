//
//  ExploreViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 17/05/2022.
//

import Foundation

protocol ExploreViewModelOutPut : AnyObject {
    func setExplorePosts(posts: [Post])
    func displayError(error: Error)
}

class ExploreViewModel {
    
    weak var output: ExploreViewModelOutPut?
    
    let postService: ExplorePostService
    
    init(postService: ExplorePostService) {
        self.postService = postService
    }
    
    func fetchAllPosts () {
        postService.fetchAllPosts {[weak self] results in
            switch results {
            case .failure(let error) :
                self?.output?.displayError(error: error)
            case .success(let posts) :
                self?.output?.setExplorePosts(posts: posts)
            }
        }
    }
    
}
