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
}

class LoginViewModel {
    
    weak var output: LoginViewModelOutPut?
    private let loginService: LoginService

    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    func logInUser(email: String, emailTF: UITextField, emailErrorLabel: UILabel, password: String, passwordTF: UITextField, passwordErrorLabel: UILabel, viewController: UIViewController) {
        
        //hide error until verify
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        
        //verify if textfields are empty
        if emailTF.text == "" { TextFieldErrorAnimation().textfieldAnimation(textfield: emailTF) }
        if passwordTF.text == "" { TextFieldErrorAnimation().textfieldAnimation(textfield: passwordTF) }
        
        loginService.loginUserWith(email: email, password: password) {[weak self] results in
            switch results {
            case .success(()) : self?.output?.switchToFeedViewController()
            case .failure(let error):
                switch error {
                    //animate the textfield
                    //show the error under the textfield
                case .emailNotFormated:
                    TextFieldErrorAnimation().textfieldAnimation(textfield: emailTF)
                    emailErrorLabel.isHidden = false
                    emailErrorLabel.text = error.description
                case .FIRAuthErrorCodeInvalidEmail:
                    TextFieldErrorAnimation().textfieldAnimation(textfield: emailTF)
                    emailErrorLabel.isHidden = false
                    emailErrorLabel.text = error.description
                case .FIRAuthErrorCodeUserDisabled:
                    AlertManager().showErrorAlert(viewcontroller: viewController, error: error.description)
                case .FIRAuthErrorCodeWrongPassword:
                    TextFieldErrorAnimation().textfieldAnimation(textfield: passwordTF)
                    passwordErrorLabel.isHidden = false
                    passwordErrorLabel.text = error.description
                case .FIRAuthErrorCodeUnkown:
                    AlertManager().showErrorAlert(viewcontroller: viewController, error: error.description)
                }
            }
        }
    }
}
