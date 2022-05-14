//
//  CommentModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 13/05/2022.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Comment: Decodable, Identifiable {
    @DocumentID var id: String?
    let comment: String
    let postId: String
    let uid: String
    let date: Timestamp
    
    var user: User?
    var post: Post?
}
