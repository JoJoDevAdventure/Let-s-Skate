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

class UserManager: FeedUserService {
    
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
    
    
}
