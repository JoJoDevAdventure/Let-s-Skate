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
}

protocol ChatService {
    func getCurrentUser() async throws -> User
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
    
    public func getCurrentUser() async throws -> User {
        guard let currentUser = currentUser else { throw MessagesError.ErrorFetchingMessages}
        do {
            let currentUser = try await fireRef.collection("users").document(currentUser.uid).getDocument(as: User.self)
            return currentUser
        } catch {
            throw error
        }
    }
    
    public func fetchAllMessages(forUser: User) async throws -> [Message] {
        guard let currentUser = currentUser else { throw MessagesError.ErrorFetchingMessages }
        guard let userID = forUser.id else { throw MessagesError.ErrorNotValidUser }
        var messages: [MessageDB]?
        var finalMessages = [Message]()
        do {
            fireRef.collection("users").document(currentUser.uid).collection(userID).addSnapshotListener({ snapshot, error in
                messages = snapshot?.documents.map({try! $0.data(as: MessageDB.self)})
            })
            guard let messages = messages else {
                throw MessagesError.ErrorFetchingMessages
            }
            for message in messages {
                let user = try await fireRef.collection("users").document(message.senderID).getDocument(as: User.self)
                let sender = Sender(photoURL: user.profileImageUrl, senderId: user.id!, displayName: user.nickname)
                let fMessage = Message(messageId: message.id!, sender: sender , sentDate: message.date, kind: .text(message.content))
                finalMessages.append(fMessage)
            }
            return finalMessages
        } catch {
            throw error
        }
    }
    
}
