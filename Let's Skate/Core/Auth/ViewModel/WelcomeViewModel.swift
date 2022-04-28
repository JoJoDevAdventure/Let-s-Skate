//
//  WelcomeViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 28/04/2022.
//

import Foundation

protocol WelcomeViewModelOutPut: AnyObject {
    
}

class WelcomeViewModel {
    
    weak var output:WelcomeViewModelOutPut?
    let verificationService: UserEmailVerificationService
    
    init(VerificationService: UserEmailVerificationService) {
        self.verificationService = VerificationService
    }
    
    func verifyUserEmail() {
        verificationService.sendEmailVerification { suceess in
            
            if suceess {
                
            } else {
                
            }
            
        }
    }

}
