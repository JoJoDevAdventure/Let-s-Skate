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
}

class FeedViewModel: ObservableObject {
    
    weak var output: FeedViewModelOutPut?
    let logoutService: LogOutService
    let userService: FeedUserService
    
    init(logoutService: LogOutService, userService: FeedUserService) {
        self.logoutService = logoutService
        self.userService = userService
    }
    
    func logOut() {
        logoutService.logOutUser()
        output?.returnToLoginScreen()
    }
    
    func fetchCurrentUser() {
        let uid = userService.getCurrentUser()
        guard let uid = uid else {
            return
        }
        userService.fetchUser(withUid: uid) {[weak self] results in
            switch results {
            case .success(let user):
                let nickName = user.nickname == "" ? user.username : user.nickname
                SDWebImageDownloader.shared.downloadImage(with: URL(string: user.profileImageUrl)) { image, _, error, _ in
                    guard let image = image else {
                        self?.output?.showErrorFetchingCurrentUser(errorLocalizedDescription: error!.localizedDescription as String)
                        return
                    }
                    self?.output?.setUserInformations(profileImage: image , username: user.username, nickname: nickName)
                }
            case .failure(let error):
                self?.output?.showErrorFetchingCurrentUser(errorLocalizedDescription: error.localizedDescription as String)
            }
        }
    }
    
}
