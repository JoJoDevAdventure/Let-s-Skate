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
                self?.output?.setUserInformations(user: user)
            case .failure(let error):
                self?.output?.showError(Error: error)
            }
        }
    }
    
}
