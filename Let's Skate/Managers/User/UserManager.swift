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
    func fetchFollowers(user: User, completion: @escaping (Result<[User], Error>) -> Void)
    func fetchFollowing(user: User, completion: @escaping (Result<[User], Error>) -> Void)
}

protocol SearchUserService {
    func searchUserByUsername(username: String, completion: @escaping (Result<[User], Error>) -> Void)
}

class UserManager: FeedUserService, ProfileUserService, SearchUserService {
    
    init() {}
    
    let fireRef = Firestore.firestore()
    
    // get the current user
    func getCurrentUser() -> String? {
        guard let user = Auth.auth().currentUser else { return nil }
        return user.uid
    }
    
    // fetch user
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
    
    // check if the user == current user
    func verifyIfUserIsCurrentUser(user: User) -> Bool? {
        guard let currentUid =  Auth.auth().currentUser?.uid else { return nil }
        if currentUid == user.id {
            return true
        } else {
            return false
        }
    }
    
    // check if current user is subbed to user
    func checkIfUserIsSubbed(user: User, completion: @escaping (Result<User, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let userId = user.id else { return }
        fireRef.collection("users").document(currentUser.uid).collection("user-following").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                completion(.failure(error!))
                return
            }
            var Nuser = user
            Nuser.subed = false
            documents.forEach { document in
                if document.documentID == userId {
                    Nuser.subed = true
                    return
                }
            }
            completion(.success(Nuser))
        }
    }
    
    // follow & unfollow user
    func followUnfollowUser(user: User, completion: @escaping (Result<User,Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let userUid = user.id else { return }
        guard var isSubbed = user.subed else { return }
        if isSubbed {
            fireRef.collection("users").document(currentUser.uid).collection("user-following").document(userUid).delete()
            fireRef.collection("users").document(userUid).collection("user-followers").document(currentUser.uid).delete()
            isSubbed.toggle()
            var Nuser = user
            Nuser.subed = isSubbed
            completion(.success(Nuser))
            
        } else if !isSubbed {
            fireRef.collection("users").document(currentUser.uid).collection("user-following").document(userUid).setData([:])
            fireRef.collection("users").document(userUid).collection("user-followers").document(currentUser.uid).setData([:])
            isSubbed.toggle()
            var Nuser = user
            Nuser.subed = isSubbed
            completion(.success(Nuser))
        }
    }
    
    func fetchFollowers(user: User, completion: @escaping (Result<[User], Error>) -> Void) {
        guard let uid = user.id else { return }
        fireRef.collection("users").document(uid).collection("user-followers").getDocuments { snapshot, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let documents = snapshot?.documents else { return }
            
            var followers: [User] = []
            guard !documents.isEmpty else {
                completion(.success(followers))
                return
            }
            documents.forEach {[weak self] document in
                let userId = document.documentID
                self?.fetchUser(withUid: userId) { results in
                    switch results {
                    case .success(let user) :
                        followers.append(user)
                        completion(.success(followers))
                    case .failure(let error) :
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func fetchFollowing(user: User, completion: @escaping (Result<[User], Error>) -> Void) {
        guard let uid = user.id else { return }
        fireRef.collection("users").document(uid).collection("user-following").getDocuments { snapshot, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let documents = snapshot?.documents else { return }
            
            var following: [User] = []
            guard !documents.isEmpty else {
                completion(.success(following))
                return
            }
            documents.forEach {[weak self] document in
                let userId = document.documentID
                self?.fetchUser(withUid: userId) { results in
                    switch results {
                    case .success(let user) :
                        following.append(user)
                        completion(.success(following))
                    case .failure(let error) :
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func searchUserByUsername(username: String, completion: @escaping (Result<[User], Error>) -> Void) {
        // fetch all users
        
        fireRef.collection("users").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            var users: [User] = []
            
            documents.forEach { document in
                if let user = try?  document.data(as: User.self) {
                    users.append(user)
                }
            }
            users = users.filter({
                $0.username.contains("@\(username.lowercased())") || $0.nickname.contains(username)
            })
            completion(.success(users))
        }
        
        
        // filter by username
        
    }
    
}
