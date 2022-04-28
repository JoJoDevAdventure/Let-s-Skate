//
//  RegistrationViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 27/04/2022.
//

import Foundation
import UIKit

protocol RegistrationViewModelOutPut : AnyObject {
    func RegistrationViewModelGoToWelcomeView(username: String)
}

class RegistrationViewModel {
    
    weak var output: RegistrationViewModelOutPut?
    private let registrationService: RegistrationService
    
    init(registrationService: RegistrationService) {
        self.registrationService = registrationService
    }
    
    
    func RegisterNewUserWith(usernameTF: UITextField, usernameErrorLabel: UILabel, emailTF: UITextField, emailErrorLabel: UILabel, passwordTF: UITextField, passwordErrorLabel: UILabel) {
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        usernameErrorLabel.isHidden = true
        let username = validateUsername(textfield: usernameTF, usernameErrorLabel: usernameErrorLabel)
        if emailTF.text == "" {
            TextFieldErrorAnimation().textfieldAnimation(textfield: emailTF)
        }
        let email  = emailTF.text
        
        guard passwordTF.text != "" else {
            TextFieldErrorAnimation().textfieldAnimation(textfield: passwordTF)
            return
        }
        let password = passwordTF.text
        
        guard let email = email else {
            return
        }

        guard let password = password else {
            return
        }

        guard let username = username else {
            return
        }
        
        print("DEBUG: REGISTRING")
        registrationService.registerUserWith(email: email, username: username, password: password) {[weak self] results in
            switch results {
            case .success(()) :
                self?.output?.RegistrationViewModelGoToWelcomeView(username: username)
            case .failure(let error) :
                switch error {
                case .FIRAuthErrorCodeInvalidEmail:
                    TextFieldErrorAnimation().textfieldAnimation(textfield: emailTF)
                    emailErrorLabel.isHidden = false
                    emailErrorLabel.text = error.description
                case .FIRAuthErrorCodeEmailAlreadyInUse:
                    TextFieldErrorAnimation().textfieldAnimation(textfield: emailTF)
                    emailErrorLabel.isHidden = false
                    emailErrorLabel.text = error.description
                case .FIRAuthErrorCodeOperationNotAllowed:
                    TextFieldErrorAnimation().textfieldAnimation(textfield: emailTF)
                    TextFieldErrorAnimation().textfieldAnimation(textfield: passwordTF)
                    TextFieldErrorAnimation().textfieldAnimation(textfield: usernameTF)
                    emailErrorLabel.isHidden = false
                    emailErrorLabel.text = error.description
                case .FIRAuthErrorCodeWeakPassword:
                    TextFieldErrorAnimation().textfieldAnimation(textfield: emailTF)
                    passwordErrorLabel.isHidden = false
                    passwordErrorLabel.text = error.description
                }
            }
        }
        
    }
    
    
    private func validateUsername(textfield: UITextField, usernameErrorLabel: UILabel) -> String? {
        guard let username = textfield.text else {
            TextFieldErrorAnimation().textfieldAnimation(textfield: textfield)
            return nil
        }
        
        guard username.count > 3 else {
            TextFieldErrorAnimation().textfieldAnimation(textfield: textfield)
            usernameErrorLabel.text = "Username too short."
            usernameErrorLabel.isHidden = false
            return nil
        }
        
        guard username.count < 12 else {
            TextFieldErrorAnimation().textfieldAnimation(textfield: textfield)
            usernameErrorLabel.text = "Username too long."
            usernameErrorLabel.isHidden = false
            return nil
        }
        
        guard username.isOnlyNumberAndLetter else {
            TextFieldErrorAnimation().textfieldAnimation(textfield: textfield)
            usernameErrorLabel.text = "Username must contain only letters and numbers"
            usernameErrorLabel.isHidden = false
            return nil
        }
        
        return textfield.text
    }
    
}
