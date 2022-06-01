//
//  ConfirmButton.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 01/06/2022.
//

import UIKit

class ConfirmInformationButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        setTitle("Confirm", for: .normal)
        setTitleColor(UIColor().DarkMainColor(), for: .normal)
        backgroundColor = UIColor().lightMainColor()
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderColor = UIColor().DarkMainColor().cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 2, height: 2)
    }

}
