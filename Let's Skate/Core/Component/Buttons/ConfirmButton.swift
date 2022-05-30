//
//  ConfirmButton.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 30/05/2022.
//

import UIKit

class ConfirmButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        setTitle("Post", for: .normal)
        backgroundColor = UIColor().DarkMainColor()
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
}
