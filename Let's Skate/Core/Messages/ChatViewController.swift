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
    var sender: Sender
    
    // MARK: - View Model
    private let viewModel: ChatViewModel
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        self.sender = viewModel.sender
        super.init(nibName: nil, bundle: nil)
        
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
        
        messageInputBar.contentView.backgroundColor = UIColor().lightMainColor()
        messageInputBar.backgroundView.backgroundColor = UIColor().lightMainColor()
        messageInputBar.inputAccessoryView?.tintColor = UIColor().DarkMainColor()
        messageInputBar.inputTextView.placeholderTextColor = UIColor().DarkMainColor()
        messageInputBar.inputTextView.textColor = .black
        messageInputBar.sendButton.tintColor = UIColor().DarkMainColor()
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.setMessageIncomingMessagePadding(UIEdgeInsets(top: 0, left: 4, bottom: 10, right: 50))
            layout.setMessageOutgoingMessagePadding(UIEdgeInsets(top: 0, left: 60, bottom: 10, right: 4))
        }
        
    }
    
    // MARK: - Functions
    
    private func testMessage() {
        messages.append(Message(sender: sender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello World Message")))
        messages.append(Message(sender: selfSender,
                                messageId: "2",
                                sentDate: Date(),
                                kind: .text("Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message")))
        messages.append(Message(sender: sender,
                                messageId: "3",
                                sentDate: Date(),
                                kind: .text("Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message ")))
        messages.append(Message(sender: sender,
                                messageId: "4",
                                sentDate: Date(),
                                kind: .text("Hello")))
        messages.append(Message(sender: selfSender,
                                messageId: "5",
                                sentDate: Date(),
                                kind: .text("Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message Hello World Message")))
        messages.append(Message(sender: selfSender,
                                messageId: "6",
                                sentDate: Date(),
                                kind: .text("Hello World Message Hello World Message Hello World Message")))
        
    }
    
    // MARK: - Network Manager calls
    
    
}

// MARK: - Extension : Messages
extension ChatViewController: MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        if message.sender.senderId == selfSender.senderId {
            return .bubbleTail(MessageStyle.TailCorner.bottomRight, MessageStyle.TailStyle.pointedEdge)
        } else {
            return .bubbleTail(MessageStyle.TailCorner.bottomLeft, MessageStyle.TailStyle.pointedEdge)
        }
        
    }
    
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
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if message.sender.senderId == selfSender.senderId {
            avatarView.isHidden = true
        } else {
            avatarView.isHidden = false
            avatarView.sd_setImage(with: URL(string: sender.photoURL))
        }
    }
}

