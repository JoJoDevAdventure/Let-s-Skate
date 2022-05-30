//
//  CancelButton.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 30/05/2022.
//

import UIKit

class CancelButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        setTitle("Cancel", for: .normal)
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
