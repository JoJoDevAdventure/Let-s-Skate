//
//  MessageModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 25/05/2022.
//

import Foundation
import MessageKit
import FirebaseFirestoreSwift

struct MessageDB: Decodable {
    @DocumentID var id: String?
    var senderID: String
    var senderUser: User?
    var date: Date
    var content: String
}

struct Message: MessageType {
    var messageId: String
    var sender: SenderType
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}
