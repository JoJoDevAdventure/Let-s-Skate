//
//  ChatViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 01/06/2022.
//

import Foundation

class ChatViewModel {
    
    private let service: ChatService
    private let chatWith: User
    
    init(service: ChatService, user: User) {
        self.service = service
        self.chatWith = user
    }
    
}
