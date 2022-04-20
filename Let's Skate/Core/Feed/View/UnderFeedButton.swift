//
//  UnderFeedButton.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 17/04/2022.
//

import UIKit

class UnderFeedButton: UIButton {
    
    func setupButton(with imageName : String) {
        let buttonImage = UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        setImage(buttonImage, for: .normal)
        translatesAutoresizingMaskIntoConstraints  = false
        tintColor = .label
    }
    
}
