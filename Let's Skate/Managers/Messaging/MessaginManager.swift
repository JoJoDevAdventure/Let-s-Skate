//
//  MessaginManager.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 25/05/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import RealmSwift
import MessageKit

enum MessagesError: Error, CaseIterable {
    case ErrorFetchingMessages
    case ErrorGettingCurrentUser
    case ErrorNotValidUser
    case NoMessages
    case ErrorMessageIsNotString
    
}

protocol ChatService {
    func fetchAllMessages(forUser: User, completion: (Result<[Message], Error>) -> Void) async
    func sendMessageTo(to user: User, message: Message) async throws
}

protocol AllMessagesService {
    func fetchAllUserConversations() async throws -> [User]
}

final class MessagingManager: ChatService, AllMessagesService {
        
    init() {}
    
    let fireRef = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    
    /// fetch all users that
    public func fetchAllUserConversations() async throws -> [User] {
        guard let currentUser = currentUser else { throw MessagesError.ErrorFetchingMessages }
        var users = [User]()
        do {
            let snapshot = try await fireRef.collection("users").document(currentUser.uid).collection("conversations").getDocuments()
            let documents = snapshot.documents
            guard !documents.isEmpty else { return []}
            for document in documents {
                let user = try await fireRef.collection("users").document(document.documentID).getDocument(as: User.self)
                users.append(user)
            }
        } catch {
            throw error
        }
        return users
    }
    
    public func fetchAllMessages(forUser: User, completion: @escaping (Result<[Message], Error>) -> Void) {
        
        guard let currentUser = currentUser else {
            completion(.failure(MessagesError.ErrorFetchingMessages))
            return
        }
        guard let userID = forUser.id else {
            completion(.failure(MessagesError.ErrorNotValidUser))
            return
        }
        
        var messages: [MessageDB]?
        fireRef.collection("users").document(currentUser.uid).collection("conversations").document(userID).collection("messages").addSnapshotListener { snapshot, error in
            messages = snapshot?.documents.map({try! $0.data(as: MessageDB.self)})
            
            guard let messages = messages else {
                completion(.failure(MessagesError.NoMessages))
                return
            }
            
            
        }
    }


    public func sendMessageTo(to user: User, message: Message) async throws {
        guard let userID = currentUser?.uid else { throw MessagesError.ErrorNotValidUser }
        guard let reciverID = user.id else { throw MessagesError.ErrorNotValidUser }
        // transform Message to MessageDB
        var messageText = ""
        switch message.kind {
        case .text(let text) :
            messageText = text
        default :
            break
        }
        let messageDB = MessageDB(id: nil, senderID: userID, senderUser: nil, date: message.sentDate, content: messageText)
        
        let data =
        ["senderID":userID,
         "date":messageDB.date,
         "content":messageText] as [String : Any]
        do {
            // insert in current user conversation
            try await fireRef.collection("users").document(userID).collection("conversations").document(reciverID).collection("messages").document().setData(data)
            // insert in reciver collection
            try await fireRef.collection("users").document(reciverID).collection("conversations").document(userID).collection("messages").document().setData(data)
        } catch {
            
        }
        
    }
    
}
