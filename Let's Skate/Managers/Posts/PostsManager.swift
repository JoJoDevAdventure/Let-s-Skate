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
    func getCurrentUserNickname(completion: @escaping (Result<String, Error>) -> Void )
}

class PostsManager: NewPostService {
    
    init() {}
    
    let storeRef = Firestore.firestore()
    
    let currentUserUid = Auth.auth().currentUser?.uid
    
    
    func getCurrentUserNickname(completion: @escaping (Result<String, Error>) -> Void ){
        
        guard let uid = currentUserUid else {
            return }
        storeRef.collection("users").document(uid).getDocument { snapShot, error in
            guard error == nil else{
                completion(.failure(error!))
                return
            }
            
            guard let user = try? snapShot?.data(as: User.self) else { return }
            completion(.success(user.nickname))
        }
    }
    
}
