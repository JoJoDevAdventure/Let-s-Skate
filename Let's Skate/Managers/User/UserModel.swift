//
//  UserModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 04/05/2022.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct User: Identifiable, Decodable {
    @DocumentID var id: String?
    let username: String
    let nickname: String
    let email: String
    let bio: String
    let profileImageUrl: String
    let bannerImageUrl: String
    
    var posts : [Post]?
    var subed : Bool?
    
    var followers : [User]?
    var following : [User]?
}
