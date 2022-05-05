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
    func setUserInformations(bannerImage: UIImage, profileImage: UIImage, nickname: String, username: String, bio: String)
    func showError(Error: Error)
}

class ProfileViewModel {
    
    weak var output: ProfileViewModelOutPut?
    let user: User
    let userService: ProfileUserService
    
    init(user: User, userService: ProfileUserService) {
        self.user = user
        self.userService = userService
    }
    
    func getUserInformations() {
        guard let uid = user.id else {return}
        userService.fetchUser(withUid: uid) {[weak self] results in
            switch results {
            case .success(let user):
                var profileImage: UIImage?
                var bannerImage: UIImage?
                
                SDWebImageDownloader.shared.downloadImage(with: URL(string: user.profileImageUrl)) { image, _, error, _ in
                    guard error == nil else {
                        self?.output?.showError(Error: error!)
                        return
                    }
                    profileImage = image
                }
                
                SDWebImageDownloader.shared.downloadImage(with: URL(string: user.bannerImageUrl)) { image, _, error, _ in
                    guard error == nil else {
                        self?.output?.showError(Error: error!)
                        return
                    }
                    bannerImage = image
                }
                
                guard let bannerImage = bannerImage else {
                    return
                }
                
                guard let profileImage = profileImage else {
                    return
                }

                let nickName = user.nickname == "" ? "\(user.username)" : "\(user.nickname)"
                
                self?.output?.setUserInformations(bannerImage: bannerImage, profileImage: profileImage, nickname: nickName, username: "\(user.username)", bio: user.bio)
            case .failure(let error):
                self?.output?.showError(Error: error)
            }
        }
    }
    
}
