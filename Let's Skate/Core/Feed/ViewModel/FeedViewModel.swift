//
//  FeedViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 19/04/2022.
//

import Foundation

protocol FeedViewModelOutPut: AnyObject {
    func returnToLoginScreen()
}

class FeedViewModel: ObservableObject {
    
    weak var output: FeedViewModelOutPut?
    let logoutService: LogOutService
    
    init(logoutService: LogOutService) {
        self.logoutService = logoutService
    }
    
    func logOut() {
        logoutService.logOutUser()
        output?.returnToLoginScreen()
    }
    
}
