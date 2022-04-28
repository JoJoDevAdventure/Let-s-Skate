//
//  AuthHeaderView.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 23/04/2022.
//

import UIKit

class AuthHeaderView: UIView {
    
    private let firstLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 42, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 6
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = CGSize(width: 3, height: 3)
        return label
    }()
    
    private let secondLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 42, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 6
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = CGSize(width: 3, height: 3)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(first: String, second: String) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.cornerRadius = 120
        addSubview(firstLabel)
        addSubview(secondLabel)
        firstLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 150).isActive = true
        firstLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 120).isActive = true
        secondLabel.leftAnchor.constraint(equalTo: firstLabel.leftAnchor).isActive = true
        secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 20).isActive = true
            
        firstLabel.text = first
        secondLabel.text = second
        
        backgroundColor = UIColor().DarkMainColor()
    }

}
