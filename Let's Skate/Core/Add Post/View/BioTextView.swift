//
//  bioTextView.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 30/05/2022.
//

import UIKit

class BioTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        allowsEditingTextAttributes = true
        layer.borderWidth = 2
        layer.cornerRadius = 5
        autocorrectionType = .no
        backgroundColor = UIColor().lightMainColor()
        textColor = .black
        layer.borderColor = UIColor().DarkMainColor().cgColor
    }

}
