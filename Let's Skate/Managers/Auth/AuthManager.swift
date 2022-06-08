//
//  AuthManager.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 25/04/2022.
//

import Firebase
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift




protocol LoginService {
    func loginUserWith(email: String, password: String) async throws
}

protocol RegistrationService {
    func registerUserWith(email: String, username:String, password: String, completion: @escaping (Result<Void ,RegistrationErrors>) -> Void)
}
    
protocol UserVerificationService {
    func checkIfUserIsLoggedIn() -> Bool
    func checkIfUserIfVerified() -> Bool
}

protocol UserEmailVerificationService {
    func sendEmailVerification(completion: @escaping (Result<String,EmailVerificationError>) -> Void)
    func checkIfUserIfVerified() -> Bool
}

protocol LogOutService {
    func logOutUser()
}

class AuthManager: LoginService, RegistrationService, UserVerificationService, UserEmailVerificationService, LogOutService {
    
    var userSesstion: FirebaseAuth.User?
    
    init() {
        self.userSesstion = Auth.auth().currentUser
    }
    
    let AuthRef = Auth.auth()
    let StoreRef = Firestore.firestore()
    
    /// login with email and password
    func loginUserWith(email: String, password: String) async throws {
        do {
            
            guard email.contains("@") && email.contains(".")  else { throw LoginErrors.emailNotFormated }
            guard password.count > 5 else { throw LoginErrors.FIRAuthErrorCodeWrongPassword }
            
            try await AuthRef.signIn(withEmail: email, password: password)
        } catch {
            try LoginErrors.allCases.forEach({ loginError in
                if loginError.LocalizedDesc == error.localizedDescription { throw loginError }
            })
            throw LoginErrors.FIRAuthErrorCodeUnkown
        }
    }
    
    
    /// register new user with email and password
    func registerUserWith(email: String, username:String, password: String, completion: @escaping (Result<Void ,RegistrationErrors>) -> Void) {
        //Register Auth
        AuthRef.createUser(withEmail: email, password: password) {[weak self] results, error in
            if let error = error {
                print("DEBUG: " + error.localizedDescription)
                RegistrationErrors.allCases.forEach({ registrationError in
                    if registrationError.LocalizedDesc == error.localizedDescription { completion(.failure(registrationError))}
                })
            } else {
                //Insert User email and username in DataBase
                guard let user = results?.user else { return }
                let data = ["email":email, "username":"@\(username.lowercased())"]
                self?.StoreRef.collection("users").document(user.uid).setData(data) { error in
                    guard error == nil else {
                        //couldn't inser user to database
                        //delete user from auth
                        return
                    }
                    self?.userSesstion = user
                    completion(.success(()))
                }
            }
        }
    }
    
    /// check if user is logged in
    func checkIfUserIsLoggedIn() -> Bool {
        if userSesstion == nil {
            return false
        }
        return true
    }
    
    /// send email verification
    func sendEmailVerification(completion: @escaping (Result<String,EmailVerificationError>) -> Void) {
        AuthRef.currentUser?.sendEmailVerification(completion: {[weak self] error in
            guard error == nil else {
                completion(.failure(EmailVerificationError.failedToSendRequest))
                return
            }
            self?.userSesstion = self?.AuthRef.currentUser
            guard let email = self?.userSesstion?.email else { return }
            completion(.success(email))
        })
    }
    
    /// check if user is verified
    func checkIfUserIfVerified() -> Bool {
        AuthRef.currentUser?.reload(completion: nil)
        guard let user = AuthRef.currentUser else {
            return false
        }
        if user.isEmailVerified {
            userSesstion = user
            return true
        } else {
            return false
        }
    }
    
    /// log out user
    func logOutUser() {
        do {
            try AuthRef.signOut()
        } catch {
            
        }
    }
}
