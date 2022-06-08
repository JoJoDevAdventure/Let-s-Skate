//
//  LoginAuthModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 27/04/2022.
//

import Foundation
import UIKit

protocol LoginViewModelOutPut: AnyObject {
    func switchToFeedViewController()
    func LoginError(error: LoginErrors)
}

class LoginViewModel {
    
    weak var output: LoginViewModelOutPut?
    private let loginService: LoginService

    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    func logInUser(email: String, password: String) {
        Task {
            //hide error until verify
            do {
                try await loginService.loginUserWith(email: email, password: password)
            } catch {
                guard let loginError = error as? LoginErrors else { return }
                output?.LoginError(error: loginError )

            }
        }
    }
    
    public func validateTextField(emailTF: UITextField, passwordTF: UITextField) -> Bool {
        if emailTF.text == "" {
            TextFieldErrorAnimation().textfieldAnimation(textfield: emailTF)
            return false
        }
        if passwordTF.text == "" {
            TextFieldErrorAnimation().textfieldAnimation(textfield: passwordTF)
            return false
        }
        return true
    }
    
}
