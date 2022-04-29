//
//  WelcomeViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 28/04/2022.
//

import Foundation

protocol WelcomeViewModelOutPut: AnyObject {
    func verificationEmailSent(email: String)
}

class WelcomeViewModel {
    
    weak var output:WelcomeViewModelOutPut?
    private let verificationService: UserEmailVerificationService
    
    init(VerificationService: UserEmailVerificationService) {
        self.verificationService = VerificationService
    }
    
    func verifyUserEmail() {
        verificationService.sendEmailVerification {[weak self] results in
            switch results {
            case .failure(_) :
                return
            case .success(let email) :
                self?.output?.verificationEmailSent(email: email)
            }
        }
    }

}
