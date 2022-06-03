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

enum MessagesError: Error, CaseIterable {
    case ErrorFetchingMessages
    case ErrorGettingCurrentUser
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
    
}
