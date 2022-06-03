//
//  ChatViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 01/06/2022.
//

import UIKit
import MessageKit
import MessageUI

class ChatViewController: MessagesViewController {
    
    
    // MARK: - Properties
    private var messages = [Message]()
    let selfSender = Sender(photoURL: "",
                        senderId: "1",
                        displayName: "Joe Smith")
    var sender = Sender(photoURL: "",
                        senderId: "2",
                        displayName: "Jenny Smith")
    
    // MARK: - View Model
    private let viewModel: ChatViewModel
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.sender = viewModel.sender
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().DarkMainColor()
        testMessage()
        setupCollectionView()
    }
    
    // MARK: - Set up
    private func setupCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.backgroundColor = UIColor().DarkMainColor()
        messageInputBar.backgroundColor = UIColor().lightMainColor()
        messageInputBar.tintColor = UIColor().DarkMainColor()
    }
    
    // MARK: - Functions
    
    private func testMessage() {
        messages.append(Message(sender: sender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello World Message")))
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message")))
        messages.append(Message(sender: sender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message ")))
        messages.append(Message(sender: sender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello")))
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message")))
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello World Message Hello World Message Hello World Message")))
        
    }
    
    // MARK: - Network Manager calls
    
    
}

// MARK: - Extension : Messages
extension ChatViewController: MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == selfSender.senderId {
            return UIColor().lightMainColor()
        } else {
            return UIColor().lightMainColor()
        }
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == selfSender.senderId {
            return .black
        } else {
            return .black
        }
    }
}

