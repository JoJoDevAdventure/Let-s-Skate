//
//  DatabaseErrors.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 28/04/2022.
//

import Foundation

enum DatabaseErrors: Error, CaseIterable {
    case couldNotAddUserToDatabase
    
    var desc: String {
        switch self {
        case .couldNotAddUserToDatabase : return "Could not register user to database"
        }
    }
}
