//
//  EmailVerificationViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 29/04/2022.
//

import Foundation
import UIKit

protocol EmailVerificationViewModelOutPut: AnyObject {
    func emailVerificationDone()
    func emailVerificationResent()
}

class EmailVerificationViewModel {
    
    weak var output: EmailVerificationViewModelOutPut?
    
    let verificationEmailService: UserEmailVerificationService
    
    init(verificationEmailService: UserEmailVerificationService) {
        self.verificationEmailService = verificationEmailService
    }
    
    func checkEmailVerification(viewController: UIViewController) {
        let isVerified = verificationEmailService.checkIfUserIfVerified()
        if isVerified {
            output?.emailVerificationDone()
        } else {
            AlertManager.shared.showErrorAlert(viewcontroller: viewController, error: "E-mail not verified, please check your InBox")
        }
    }
    
    func resendVerificationEmail(viewController: UIViewController) {
        verificationEmailService.sendEmailVerification {[weak self] results in
            switch results {
            case .success(_) :
                self?.output?.emailVerificationResent()
            case .failure(_) :
                AlertManager.shared.showErrorAlert(viewcontroller: viewController, error: "Unable to send verification e-mail, try again later.")
            }
        }
    }
    
}
