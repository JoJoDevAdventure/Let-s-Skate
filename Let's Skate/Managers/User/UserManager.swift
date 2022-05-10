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
    func checkIfUserIsSubbed(user: User, completion: @escaping (Result<User, Error>)  -> Void)
    func followUnfollowUser(user: User, completion: @escaping (Result<User,Error>) -> Void)
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
    
    func checkIfUserIsSubbed(user: User, completion: @escaping (Result<User, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let userId = user.id else { return }
        fireRef.collection("users").document(currentUser.uid).collection("user-following").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                completion(.failure(error!))
                return
            }
            var Nuser = user
            documents.forEach { document in
                if document.documentID == userId {
                    Nuser.subed = true
                    completion(.success(Nuser))
                }
            }
            Nuser.subed = false
            completion(.success(Nuser))
        }
    }
    
    func followUnfollowUser(user: User, completion: @escaping (Result<User,Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let userUid = user.id else { return }
        guard var isSubbed = user.subed else { return }
        if isSubbed {
            isSubbed.toggle()
            var Nuser = user
            Nuser.subed = isSubbed
            fireRef.collection("users").document(currentUser.uid).collection("user-following").document(userUid).delete()
            fireRef.collection("users").document(userUid).collection("user-followers").document(currentUser.uid).delete()
            completion(.success(Nuser))
        } else if !isSubbed {
            isSubbed.toggle()
            var Nuser = user
            Nuser.subed = isSubbed
            
            fireRef.collection("users").document(currentUser.uid).collection("user-following").document(userUid).setData([:])
            fireRef.collection("users").document(userUid).collection("user-followers").document(currentUser.uid).setData([:])
            completion(.success(Nuser))
        }
    }
    
}
