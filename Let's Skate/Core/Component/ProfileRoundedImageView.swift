//
//  ProfileRoundedImageView.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 17/04/2022.
//

import UIKit

class ProfileRoundedImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupImageView() {
        image = UIImage(systemName: "person")
        tintColor = .white
        contentMode = .scaleToFill
        clipsToBounds = true
        layer.borderWidth = 3
        layer.borderColor = UIColor().DarkMainColor().cgColor
        let height = frame.height
        let width = frame.width
        let min = height > width ? width : height
        layer.cornerRadius = min/2
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .gray
        isUserInteractionEnabled = true
    }
    
}
