//
//  AuthErrors.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 27/04/2022.
//

import Foundation

enum LoginErrors : Error, CaseIterable {
    case emailNotFormated
    case FIRAuthErrorCodeInvalidEmail
    case FIRAuthErrorCodeUserDisabled
    case FIRAuthErrorCodeWrongPassword
    case FIRAuthErrorCodeUnkown
    
    var description : String {
        switch self {
        case .emailNotFormated :
            return "Invalid email adress."
        case .FIRAuthErrorCodeInvalidEmail:
            return "User not found"
        case .FIRAuthErrorCodeUserDisabled:
            return "Account disabled."
        case .FIRAuthErrorCodeWrongPassword:
            return "Invalid password."
        case .FIRAuthErrorCodeUnkown:
            return "Unknown error occured, try again later."
        }
    }
    
    var LocalizedDesc : String {
        switch self {
        case .emailNotFormated:
            return "The email address is badly formatted."
        case .FIRAuthErrorCodeInvalidEmail:
            return "There is no user record corresponding to this identifier. The user may have been deleted."
        case .FIRAuthErrorCodeUserDisabled:
            return "The user account has been disabled by an administrator."
        case .FIRAuthErrorCodeWrongPassword:
            return "The password is invalid or the user does not have a password."
        case .FIRAuthErrorCodeUnkown:
            return ""
        }
    }
}

enum RegistrationErrors : Error, CaseIterable {
    case FIRAuthErrorCodeInvalidEmail
    case FIRAuthErrorCodeEmailAlreadyInUse
    case FIRAuthErrorCodeOperationNotAllowed
    case FIRAuthErrorCodeWeakPassword
    
    var LocalizedDesc : String {
        switch self {
        case .FIRAuthErrorCodeInvalidEmail:
            return "The email address is badly formatted."
        case .FIRAuthErrorCodeEmailAlreadyInUse:
            return "The email address is already in use by another account."
        case .FIRAuthErrorCodeOperationNotAllowed:
            return ""
        case .FIRAuthErrorCodeWeakPassword:
            return "The password must be 6 characters long or more."
        }
    }
    
    var description : String {
        switch self {
        case .FIRAuthErrorCodeInvalidEmail:
            return "Invalid email adress."
        case .FIRAuthErrorCodeEmailAlreadyInUse:
            return "Email already in use! try to sign in."
        case .FIRAuthErrorCodeOperationNotAllowed:
            return ""
        case .FIRAuthErrorCodeWeakPassword:
            return "Weak password."
        }
    }
    
}

enum EmailVerificationError : Error, CaseIterable {
    case failedToSendRequest
}
