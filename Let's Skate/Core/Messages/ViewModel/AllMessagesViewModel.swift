//
//  AllMessagesViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 03/06/2022.
//

import Foundation

protocol AllMessagesViewModelOutPut: AnyObject {
    func fetchedConversations(conversations: [User])
    func showError(conversation: Error)
}

final class AllMessagesViewModel {
    
    weak var output: AllMessagesViewModelOutPut?
    
    let allMessagesService: AllMessagesService
    
    init(allMessagesService: AllMessagesService) {
        self.allMessagesService = allMessagesService
    }
    
    public func fetchAllConversations() {
        Task {
            do {
                let users = try await allMessagesService.fetchAllUserConversations()
                output?.fetchedConversations(conversations: users)
            } catch {
                output?.showError(conversation: error)
            }
        }
    }
    
}
