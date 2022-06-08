//
//  SignUp_UTest.swift
//  Let's SkateTests
//
//  Created by Youssef Bhl on 27/04/2022.
//
@testable import Let_s_Skate
import XCTest

class SignUp_UTest: XCTestCase {
    
    var signUp: RegistrationService!
    var user: User?
    
    override func setUp() {
        super.setUp()
        signUp = AuthManager()
    }
    
    override func tearDown() {
        signUp = nil
        super.tearDown()
    }

}
