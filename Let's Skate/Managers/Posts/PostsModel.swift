//
//  PostsModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 06/05/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Post: Identifiable, Decodable {
    @DocumentID var id: String?
    var bio: String
    var postUrl: String
    var uid: String
    
    var user: User?
    var liked: Bool?
}
