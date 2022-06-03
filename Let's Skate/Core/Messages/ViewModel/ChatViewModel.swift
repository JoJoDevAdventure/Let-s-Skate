//
//  ChatViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 01/06/2022.
//

import Foundation
import Network

class ChatViewModel {
    
    private let service: ChatService
    private let chatWith: User
    let sender: Sender
    
    
    init(service: ChatService, user: User) {
        self.service = service
        self.chatWith = user
        self.sender = Sender(photoURL: user.profileImageUrl, senderId: user.id!, displayName: user.username)
    }
    
}
