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
}

protocol ChatService {
    
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
    
}
