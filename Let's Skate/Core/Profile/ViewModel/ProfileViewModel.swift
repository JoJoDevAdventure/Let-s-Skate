//
//  ProfileViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 05/05/2022.
//

import Foundation
import UIKit
import SDWebImage
import SwiftUI

protocol ProfileViewModelOutPut : AnyObject {
    func setUserInformations(user: User)
    func showError(Error: Error)
    func setUserPosts(user: User)
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
                self?.output?.setUserInformations(user: user)
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
    
}
