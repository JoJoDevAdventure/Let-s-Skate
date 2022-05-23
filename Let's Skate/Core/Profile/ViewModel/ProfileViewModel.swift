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
    func subedUnsubed(user: User)
    func setButtons()
    func showItemDeletionAnimation()
    func userDidUploadNewPost(user: User)
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
    func fetchUserInformations() {
        checkIfUserIsSubed()
    }
    
    //check if current user is subbed to displayed user
    private func checkIfUserIsSubed() {
        userService.checkIfUserIsSubbed(user: user) {[weak self] resuls in
            switch resuls {
            case .failure(let error):
                self?.output?.showError(Error: error)
            case .success(let user):
                self?.user.subed = user.subed
                self?.getUserPosts()
            }
        }
    }
    
    //show dispayed user posts
    private func getUserPosts() {
        guard let uid = user.id else { return }
        postsService.fetchUserPosts(uid: uid) {[weak self] Results in
            switch Results {
            case .failure(let error):
                self?.output?.showError(Error: error)
            case .success(let user):
                self?.user.posts = user.posts
                self?.fetchFollowers()
            }
        }
    }
    
    //check if subbed to displayed user
        //sub or unsub
    func subUnsubToUser() {
        userService.followUnfollowUser(user: user) {[weak self] results in
            switch results {
            case .success(let user) :
                self?.user.subed = user.subed
                self?.fetchFollowingAndFollowers()
            case .failure(let error) :
                self?.output?.showError(Error: error)
            }
        }
    }
    
    //get user followers and following users
    private func fetchFollowers() {
        userService.fetchFollowers(user: user) {[weak self] results in
            switch results {
            case .failure(let error) :
                self?.output?.showError(Error: error)
            case .success(let followers) :
                self?.user.followers = followers
                self?.fetchFollowing()
            }
        }
    }
    
    private func fetchFollowing() {
        userService.fetchFollowing(user: user) {[weak self] results in
            switch results {
            case .failure(let error) :
                self?.output?.showError(Error: error)
            case .success(let followings) :
                self?.user.following = followings
                guard let strongSelf = self else { return }
                self?.output?.setUserInformations(user: strongSelf.user)
                self?.output?.setButtons()
            }
        }
    }
    
    private func fetchFollowingAndFollowers() {
        userService.fetchFollowing(user: user) {[weak self] results in
            switch results {
            case .failure(let error) :
                self?.output?.showError(Error: error)
            case .success(let following) :
                self?.user.following = following
                guard let strongSelf = self else { return }
                self?.userService.fetchFollowers(user: strongSelf.user) { results in
                    switch results {
                    case .success(let followers) :
                        self?.user.followers = followers
                        self?.output?.subedUnsubed(user: strongSelf.user)
                    case .failure(let error) :
                        self?.output?.showError(Error: error)
                    }
                }
            }
        }
    }
    
    func deletePost(post: Post) {
        postsService.deletePost(post: post) {[weak self] results in
            switch results {
            case .failure(let error):
                self?.output?.showError(Error: error)
            case .success(()):
                self?.output?.showItemDeletionAnimation()
            }
        }
    }
    
    func userDidUploadNewPost() {
        guard let uid = user.id else { return }
        postsService.fetchUserPosts(uid: uid) {[weak self] Results in
            switch Results {
            case .failure(let error):
                self?.output?.showError(Error: error)
            case .success(let user):
                self?.output?.userDidUploadNewPost(user: user)
            }
        }
    }
    
}
