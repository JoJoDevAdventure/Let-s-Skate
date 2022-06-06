//
//  ChatViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 01/06/2022.
//

import Foundation
import Network

protocol ChatViewModelOutPut: AnyObject{
    func fetchMessages(messages: [Message])
    func showError(error: Error)
}

class ChatViewModel {
    
    var currentUID = UserManager().getCurrentUser()
    
    weak var output: ChatViewModelOutPut?
    
    private let service: ChatService
    private let chatWith: User
    let sender: Sender
    
    
    init(service: ChatService, user: User) {
        self.service = service
        self.chatWith = user
        self.sender = Sender(photoURL: user.profileImageUrl, senderId: user.id!, displayName: user.username)
    }
    
    public func fetchMessages() {
        service.fetchAllMessages(forUser: chatWith) {[weak self] results in
            switch results {
            case .failure(let error) :
                self?.output?.showError(error: error)
            case .success(let messages) :
                self?.output?.fetchMessages(messages: messages)
            }
        }
    }
    
    public func sendMessage(message: Message) {
        Task(priority: .medium) {
            do {
                try await service.sendMessageTo(to: chatWith, message: message)
            } catch {
                output?.showError(error: error)
            }
        }
    }
    
}
