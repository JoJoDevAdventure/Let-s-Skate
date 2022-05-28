//
//  FeedViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 19/04/2022.
//

import Foundation
import UIKit
import SDWebImage

protocol FeedViewModelOutPut: AnyObject {
    
    func returnToLoginScreen()
    
    func setUserInformations(profileImage: UIImage, username: String, nickname: String)
    
    func showErrorFetchingCurrentUser(errorLocalizedDescription : String)
    
    func getCurrentUserProfile(user: User)

    func didFetchPosts(posts: [Post])

    func showErrorFetchingPosts(ErrorLocalizedDescription: String)
    
    func likedPost(post: Post)
}

class FeedViewModel: ObservableObject {
    
    weak var output: FeedViewModelOutPut?
    let logoutService: LogOutService
    let userService: FeedUserService
    let postsService: FeedPostsService
    
    init(logoutService: LogOutService, userService: FeedUserService, postsService: FeedPostsService) {
        self.logoutService = logoutService
        self.userService = userService
        self.postsService = postsService
    }
    
    //logout current user
    func logOut() {
        logoutService.logOutUser()
        output?.returnToLoginScreen()
    }
    
    // fetch user + download images -> Set UI via output
    func fetchCurrentUser() {
        Task(priority: .medium) {
            let uid = userService.getCurrentUser()
            guard let uid = uid else {
                return
            }
            do {
                let user = try await userService.fetchUser(withUid: uid)
                let nickName = user.nickname == "" ? user.username : user.nickname
                SDWebImageDownloader.shared.downloadImage(with: URL(string: user.profileImageUrl)) { image, _, error, _ in
                    guard let image = image else {
                        self.output?.showErrorFetchingCurrentUser(errorLocalizedDescription: error!.localizedDescription as String)
                        return
                    }
                    self.output?.setUserInformations(profileImage: image , username: user.username, nickname: nickName)
                }
            } catch {
                output?.showErrorFetchingPosts(ErrorLocalizedDescription: error.localizedDescription)
            }
        }
    }
    
    //return current User
    func fetchCurrentUserProfile() {
        Task(priority: .high) {
            let uid = userService.getCurrentUser()
            guard let uid = uid else {
                return
            }
            do {
                let user = try await userService.fetchUser(withUid: uid)
                DispatchQueue.main.async {
                    self.output?.getCurrentUserProfile(user: user)
                }
            } catch {
                self.output?.showErrorFetchingPosts(ErrorLocalizedDescription: error.localizedDescription)
            }
        }
        
    }
    
    //get all Posts
    func fetchAllPosts() {
        postsService.fetchAllPosts {[weak self] results in
            switch results {
            case .success(let posts):
                self?.output?.didFetchPosts(posts: posts)
            case .failure(let error):
                self?.output?.showErrorFetchingCurrentUser(errorLocalizedDescription: error.localizedDescription)
            }
        }
    }
    
    func likedUnlikedPost(post: Post) {
        postsService.likeUnlikePost(post: post) {[weak self] results in
            switch results {
            case .success(let post):
                self?.output?.likedPost(post: post)
            case .failure(let error):
                self?.output?.showErrorFetchingPosts(ErrorLocalizedDescription: error.localizedDescription)
            }
        }
    }
}
