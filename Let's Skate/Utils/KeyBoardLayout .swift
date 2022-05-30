//
//  KeyBoardLayout .swift
//  Let's Skate
//
//  Created by Youssef Bhl on 30/05/2022.
//

import UIKit

protocol KeyboardLayoutDelegate: AnyObject {
    func keyBoardShown(keyboardHeight: CGFloat)
    func keyBoardHidden(keyboardHeight: CGFloat)
}

final class KeyboardLayout: NSLayoutConstraint {
    
    static let shared = KeyboardLayout()
    
    override init() {
        super.init()
        setupObserver()
    }
    
    weak var delegate: KeyboardLayoutDelegate?
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShown(_:)),name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillBeHidden(_:)),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    var isTyping = false

    @objc func keyboardWillShown(_ notification: NSNotification) {
        if !isTyping {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                delegate?.keyBoardShown(keyboardHeight: keyboardHeight)
                isTyping.toggle()
            }
        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        if isTyping {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                delegate?.keyBoardHidden(keyboardHeight: keyboardHeight)
                isTyping.toggle()
            }
        }
    }
    
}
