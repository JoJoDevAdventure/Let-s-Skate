//
//  Posts Mabager.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 06/05/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

protocol NewPostService {
    func getCurrentUserUsername(completion: @escaping (Result<String, Error>) -> Void )
}

class PostsManager: NewPostService {
    
    let storeRef = Firestore.firestore()
    
    let currentUserUid = Auth.auth().currentUser?.uid
    
    
    func getCurrentUserUsername(completion: @escaping (Result<String, Error>) -> Void ){
        
        guard let uid = currentUserUid else {
            return }
        let currentUserUsername = storeRef.collection("users").document(uid).value(forKey: "username")
        let username = currentUserUsername as! String
        print(username)
        completion(.success(username))
    }

    
    init() {}
    

    
    
}
