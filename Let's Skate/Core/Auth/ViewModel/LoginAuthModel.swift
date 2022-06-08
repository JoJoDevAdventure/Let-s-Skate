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
    
    func logInUser(email: String, password: String) async {
        
        //hide error until verify
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        
        //verify if textfields are empty
        if emailTF.text == "" { TextFieldErrorAnimation().textfieldAnimation(textfield: emailTF) }
        if passwordTF.text == "" { TextFieldErrorAnimation().textfieldAnimation(textfield: passwordTF) }
        
        do {
            try await loginService.loginUserWith(email: email, password: password)
        } catch {
            guard let loginError = error as? LoginErrors else { return }
            output?.LoginError(error: loginError )
            switch error {
                // badly formated email
            case .emailNotFormated:
                TextFieldErrorAnimation().textfieldAnimation(textfield: emailTF)
                emailErrorLabel.isHidden = false
                emailErrorLabel.text = error.description
                self.output?.emailNotFormatedError(error: LoginErrors.emailNotFormated)
                
                // email doesn't exists
            case .FIRAuthErrorCodeInvalidEmail:
                TextFieldErrorAnimation().textfieldAnimation(textfield: emailTF)
                emailErrorLabel.isHidden = false
                emailErrorLabel.text = error.description
                self.output?.invalidEmailError(error: LoginErrors.FIRAuthErrorCodeInvalidEmail)
                
                // user disabled
            case .FIRAuthErrorCodeUserDisabled:
                AlertManager().showErrorAlert(viewcontroller: viewController, error: error.description)
                self.output?.userDisabledError(error: LoginErrors.FIRAuthErrorCodeUserDisabled)
                
                // wrond password
            case .FIRAuthErrorCodeWrongPassword:
                TextFieldErrorAnimation().textfieldAnimation(textfield: passwordTF)
                passwordErrorLabel.isHidden = false
                passwordErrorLabel.text = error.description
                
                // unknown error
            case .FIRAuthErrorCodeUnkown:
                AlertManager().showErrorAlert(viewcontroller: viewController, error: error.description)
            }
        }
    }
    
    public func validateTextField() {
        
    }
    
}
