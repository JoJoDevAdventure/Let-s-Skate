//
//  SearchViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 17/05/2022.
//

import Foundation

protocol searchViewModelOutPut : AnyObject {
    func updateUsers(users: [User])
    func showError(error: Error)
}

class SearchViewModel {
    
    weak var output: searchViewModelOutPut?
    let searchUserService: SearchUserService
    
    init(searchUserService: SearchUserService) {
        self.searchUserService = searchUserService
    }
    
    func seachUserWithUserName(username: String) {
        searchUserService.searchUserByUsername(username: username) {[weak self] results in
            switch results {
            case .success(let users):
                self?.output?.updateUsers(users: users)
            case .failure(let error):
                self?.output?.showError(error: error)
            }
        }
    }
}
