//
//  ProfileViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 05/05/2022.
//

import Foundation
import UIKit
import SDWebImage

protocol ProfileViewModelOutPut : AnyObject {
    func setUserInformations(user: User)
    func showError(Error: Error)
    func setUserPosts(user: User)
    func subbedUsubedToUser(user: User)
}

class ProfileViewModel {
    
    weak var output: ProfileViewModelOutPut?
    let user: User
    let userService: ProfileUserService
    let postsService: ProfilePostsService
    
    init(user: User, userService: ProfileUserService, postsService: ProfilePostsService) {
        self.user = user
        self.userService = userService
        self.postsService = postsService
    }
    
    func getUserInformations() {
        guard let uid = user.id else {return}
        userService.fetchUser(withUid: uid) {[weak self] results in
            switch results {
            case .success(let user):
                self?.checkIfUserIsSubed(user: user)
            case .failure(let error):
                self?.output?.showError(Error: error)
            }
        }
    }
    
    func getUserPosts(user: User) {
        guard let uid = user.id else { return }
        postsService.fetchUserPosts(uid: uid) { Results in
            switch Results {
            case .failure(let error):
                self.output?.showError(Error: error)
            case .success(let user):
                self.output?.setUserPosts(user: user)
            }
        }
    }
    
    func checkIfUserIsSubed(user: User) {
        userService.checkIfUserIsSubbed(user: user) { resuls in
            switch resuls {
            case .failure(let error):
                self.output?.showError(Error: error)
            case .success(let user):
                self.output?.setUserInformations(user: user)
            }
        }
    }
    
    func subUnsubToUser(user: User) {
//        userService.followUnfollowUser(user: user) { results in
//            switch results {
//            case .success(()) :
//                self.output?.subbedUsubedToUser(user: user)
//            case .failure(let error) :
//                self.output?.showError(Error: error)
//            }
//        }
        output?.subbedUsubedToUser(user: user)
    }
    
}
