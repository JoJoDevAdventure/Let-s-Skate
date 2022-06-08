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
    
    func test_email_is_badly_formated() async {
        do {
            try await signUp.loginUserWith(email: "youssef", password: "")
            XCTAssert(user == nil)
        } catch {
            // verify that we got the correct error
            XCTAssert(error.localizedDescription == LoginErrors.emailNotFormated.LocalizedDesc)
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
