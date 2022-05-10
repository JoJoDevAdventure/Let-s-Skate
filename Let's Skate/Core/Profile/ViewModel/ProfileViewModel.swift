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
    func setUserSubscriptionStatus(user: User)
    func showError(Error: Error)
    func setUserPosts(user: User)
    func subedUnsubed(user: User)
}

class ProfileViewModel {
    
    // MARK: - Propreties
    
    weak var output: ProfileViewModelOutPut?
    var user: User
    let userService: ProfileUserService
    let postsService: ProfilePostsService
    
    init(user: User, userService: ProfileUserService, postsService: ProfilePostsService) {
        self.user = user
        self.userService = userService
        self.postsService = postsService
    }
    
    // MARK: - Functions
    
    //get displayed user informations
    func getUserInformations() {
        guard let uid = user.id else {return}
        userService.fetchUser(withUid: uid) {[weak self] results in
            switch results {
            case .success(let user):
                self?.user = user
                self?.output?.setUserInformations(user: user)
            case .failure(let error):
                self?.output?.showError(Error: error)
            }
        }
    }
    
    //check if current user is subbed to displayed user
    func checkIfUserIsSubed() {
        userService.checkIfUserIsSubbed(user: user) { resuls in
            switch resuls {
            case .failure(let error):
                self.output?.showError(Error: error)
            case .success(let user):
                self.user = user
                self.output?.setUserSubscriptionStatus(user: user)
            }
        }
    }
    
    //show dispayed user posts
    func getUserPosts() {
        guard let uid = user.id else { return }
        postsService.fetchUserPosts(uid: uid) { Results in
            switch Results {
            case .failure(let error):
                self.output?.showError(Error: error)
            case .success(let user):
                self.user = user
                self.output?.setUserPosts(user: user)
            }
        }
    }
    
    //check if subbed to displayed user
        //sub or unsub
    func subUnsubToUser() {
        userService.followUnfollowUser(user: user) { results in
            switch results {
            case .success(let user) :
                self.user = user
                self.output?.subedUnsubed(user: user)
            case .failure(let error) :
                self.output?.showError(Error: error)
            }
        }
    }
    
}
