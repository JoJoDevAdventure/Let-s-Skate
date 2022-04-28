//
//  AuthTextfield.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 22/04/2022.
//

import UIKit

class AuthTextfield: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup() {
        textColor = .white
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.white.cgColor
        backgroundColor = UIColor.init(white: 1, alpha: 0.1)
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        widthAnchor.constraint(equalToConstant: 280).isActive = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.cornerRadius = 10
        attributedPlaceholder = NSAttributedString(
            string: "XXXXXXXXXXXXX",
            attributes : [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
    }
    
}
