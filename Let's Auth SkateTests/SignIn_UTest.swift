//
//  Let_s_SkateTests.swift
//  Let's SkateTests
//
//  Created by Youssef Bhl on 27/04/2022.
//

@testable import Let_s_Skate
import XCTest

class SignIn_UTest: XCTestCase {
    
    var signUp: LoginService!
    var user: User?
    
    override func setUp() {
        super.setUp()
        signUp = AuthManager()
    }
    
    override func tearDown() {
        signUp = nil
        super.tearDown()
    }
    
    func test_email_is_badly_formated_password_empty() async {
        do {
            try await signUp.loginUserWith(email: "youssef", password: "")
            XCTAssert(user == nil)
        } catch {
            // verify that we got the correct error
            XCTAssert(error as! LoginErrors == LoginErrors.emailNotFormated)
        }
    }
    
    func test_email_is_badly_formated_password_not_empty() async {
        do {
            try await signUp.loginUserWith(email: "youssef", password: "123412341234")
            XCTAssert(user == nil)
        } catch {
            // verify that we got the correct error
            XCTAssert(error as! LoginErrors == LoginErrors.emailNotFormated)
        }
    }
    
    func test_email_correct_but_doesnt_exsist() async {
        do {
            try await signUp.loginUserWith(email: "youssef@gmail.com", password: "123412341234")
            XCTAssert(user == nil)
        } catch {
            // verify that we got the correct error
            XCTAssert(error as! LoginErrors == LoginErrors.FIRAuthErrorCodeInvalidEmail)
        }
    }
    
    func test_email_correct_exist_but_wrong_password() async {
        do {
            try await signUp.loginUserWith(email: "youssef.b.air2@gmail.com", password: "1111111")
            XCTAssert(user == nil)
        } catch {
            // verify that we got the correct error
            XCTAssert(error as! LoginErrors == LoginErrors.FIRAuthErrorCodeWrongPassword)
        }
    }
    
    func test_login_to_disabled_account() async {
        do {
            try await signUp.loginUserWith(email: "youssef.b.air3@gmail.com", password: "12341234")
            XCTAssert(user == nil)
        } catch {
            // verify that we got the correct error
            print(error)
            XCTAssert(error as! LoginErrors == LoginErrors.FIRAuthErrorCodeUserDisabled)
        }
    }
    
    /// Turn off mac connection
    func test_no_connection_while_login() async {
        do {
            try await signUp.loginUserWith(email: "youssef.b.air2@gmail.com", password: "12341234")
        } catch {
            XCTAssert(error as! LoginErrors == LoginErrors.FIRAuthErrorCodeUnkown)
        }
    }
    
    func test_email_is_valid_and_correct_should_login() async {
        do {
            
            try await signUp.loginUserWith(email: "youssef.b.air2@gmail.com", password: "12341234")
            user = User(id: "", username: "", nickname: "", email: "", bio: "", profileImageUrl: "", bannerImageUrl: "", posts: nil, subed: nil, followers: nil, following: nil)
            XCTAssert(user != nil)
        } catch {
            XCTFail("No errors, User logged in")
        }
    }
}
