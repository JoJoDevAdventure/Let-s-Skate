//
//  UserManager.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 04/05/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

protocol FeedUserService {
    func fetchUser(withUid uid: String, completion: @escaping (Result<User,Error>) -> Void)
    func getCurrentUser() -> String?
}

protocol ProfileUserService {
    func fetchUser(withUid uid: String, completion: @escaping (Result<User,Error>) -> Void)
    func getCurrentUser() -> String?
    func verifyIfUserIsCurrentUser(user: User) -> Bool?
}

class UserManager: FeedUserService, ProfileUserService {
    
    init() {
        
    }
    
    let fireRef = Firestore.firestore()
    
    func getCurrentUser() -> String? {
        guard let user = Auth.auth().currentUser else { return nil }
        return user.uid
    }
    
    func fetchUser(withUid uid: String, completion: @escaping (Result<User,Error>) -> Void) {
        fireRef.collection("users")
            .document(uid)
            .getDocument { snapshot , error in
                guard let snapshot = snapshot else {
                    completion(.failure(error!))
                    return
                }
                guard let user = try? snapshot.data(as: User.self) else { return }
                completion(.success(user))
            }
    }
    
    func verifyIfUserIsCurrentUser(user: User) -> Bool? {
        guard let currentUid =  Auth.auth().currentUser?.uid else { return nil }
        if currentUid == user.id {
            return true
        } else {
            return false
        }
    }
    
}
