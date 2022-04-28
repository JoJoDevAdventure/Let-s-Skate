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
    func loginUserWith(email: String, password: String, completion: @escaping (Result<Void ,LoginErrors>) -> Void)
}

protocol RegistrationService {
    func registerUserWith(email: String, username:String, password: String, completion: @escaping (Result<Void ,RegistrationErrors>) -> Void)
}
    
protocol UserVerificationService {
    func checkIfUserIsLoggedIn() -> Bool
}

protocol UserEmailVerificationService {
    func sendEmailVerification(completion: @escaping (Bool) -> Void)
    func checkIfUserIfVerified() -> Bool
}

class AuthManager: LoginService, RegistrationService, UserVerificationService {
    
    var userSesstion: FirebaseAuth.User?
    
    init() {
        self.userSesstion = Auth.auth().currentUser
    }
    
    let AuthRef = Auth.auth()
    let StoreRef = Firestore.firestore()
    
    func loginUserWith(email: String, password: String, completion: @escaping (Result<Void ,LoginErrors>) -> Void) {
        AuthRef.signIn(withEmail: email, password: password) {[weak self] results, error in
            if let error = error {
                print("DEBUG: " + error.localizedDescription)
                LoginErrors.allCases.forEach({ loginError in
                    if loginError.LocalizedDesc == error.localizedDescription { completion(.failure(loginError))}
                })
            } else {
                completion(.success(()))
                guard let user = results?.user else { return }
                self?.userSesstion = user
            }
        }
    }
    
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
                let data = ["email":email, "username":username]
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
    
    func checkIfUserIsLoggedIn() -> Bool {
        if userSesstion == nil {
            return false
        }
        return true
    }
    
    func sendEmailVerification(completion: @escaping (Bool) -> Void) {
        AuthRef.currentUser?.sendEmailVerification(completion: {[weak self] error in
            guard error == nil else {
                completion(false)
                return
            }
            self?.userSesstion = self?.AuthRef.currentUser
            completion(true)
        })
    }
    
    func checkIfUserIfVerified() -> Bool {
        guard let userSesstion = userSesstion else {
            return false
        }
        
        if userSesstion.isEmailVerified {
            return true
        } else {
            return false
        }
        
    }
}
