//
//  Messages Errors.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 06/06/2022.
//

import Foundation

/// Faced errors while message process
enum MessagesError: Error, CaseIterable {
    case ErrorFetchingMessages
    case ErrorGettingCurrentUser
    case ErrorNotValidUser
    case NoMessages
    case ErrorMessageIsNotString
}
