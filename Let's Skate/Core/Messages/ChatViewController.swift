//
//  ChatViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 01/06/2022.
//

import UIKit
import MessageKit
import MessageUI
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    
    // MARK: - Properties
    private var messages = [Message]()
    var selfSender = Sender(photoURL: "",
                            senderId: "",
                        displayName: "")
    var sender: Sender
    
    private let noConversationsWithUserLabel: UILabel = {
        let label = UILabel()
        label.text = "No messages yet.\nDo the first step !"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.isHidden = true
        return label
    }()
    
    // MARK: - View Model
    private let viewModel: ChatViewModel
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        self.sender = viewModel.sender
        super.init(nibName: nil, bundle: nil)
        self.selfSender = Sender(photoURL: "", senderId: viewModel.currentUID!, displayName: "")
        viewModel.output = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().DarkMainColor()
        setupCollectionView()
        fetchAllMessages()
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
            layout.setMessageIncomingMessagePadding(UIEdgeInsets(top: 0, left: 4, bottom: 1, right: 50))
            layout.setMessageOutgoingMessagePadding(UIEdgeInsets(top: 0, left: 60, bottom: 1, right: 4))
        }
        messageInputBar.inputTextView.inputBarAccessoryView?.delegate = self
        view.addSubview(noConversationsWithUserLabel)
        noConversationsWithUserLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noConversationsWithUserLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    // MARK: - Functions

    
    // MARK: - Network Manager calls
    
    private func fetchAllMessages() {
        viewModel.fetchMessages()
    }
    
}

// MARK: - Extension : Messages
extension ChatViewController: MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        if message.sender.senderId == selfSender.senderId {
            if isNextMessageSameSender(at: indexPath) {
                return .bubble
            } else {
                return .bubbleTail(MessageStyle.TailCorner.bottomRight, MessageStyle.TailStyle.pointedEdge)
            }
        } else {
            if isNextMessageSameSender(at: indexPath) {
                return .bubble
            } else {
                return .bubbleTail(MessageStyle.TailCorner.bottomLeft, MessageStyle.TailStyle.pointedEdge)
            }
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
            avatarView.isHidden = isNextMessageSameSender(at: indexPath)
            avatarView.sd_setImage(with: URL(string: sender.photoURL))
        }
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messages.count else { return false }
        return messages[indexPath.section].sender.displayName == messages[indexPath.section + 1].sender.displayName
    }

}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(messageId: "", sender: selfSender, sentDate: Date(), kind: .text(text))
        viewModel.sendMessage(message: message)
        inputBar.inputTextView.text = ""
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        //
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        //
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) {
        //
    }
    
}

extension ChatViewController: ChatViewModelOutPut {
    
    func noMessagesWithThisUser() {
        noConversationsWithUserLabel.isHidden = false
    }
    
    func fetchMessages(messages: [Message]) {
        self.messages = messages
        DispatchQueue.main.async {
            self.noConversationsWithUserLabel.isHidden = true
            self.messagesCollectionView.reloadData()
        }
    }
    
    func showError(error: Error) {
        AlertManager().showErrorAlert(viewcontroller: self, error: error.localizedDescription)
    }
    
}
