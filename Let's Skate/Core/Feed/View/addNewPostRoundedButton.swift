//
//  addNewPostRoundedButton.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 28/05/2022.
//

import UIKit

class addNewPostRoundedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        tintColor = .white
        setImage(image, for: .normal)
        heightAnchor.constraint(equalToConstant: 70).isActive = true
        widthAnchor.constraint(equalToConstant: 70).isActive = true
        backgroundColor = UIColor().DarkMainColor()
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 35
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 0.5
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 1, height: 1)
        isHidden = false
    }

}
