//
//  DescWelcomeLabel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 25/04/2022.
//

import UIKit

class DescWelcomeLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        font = .systemFont(ofSize: 28, weight: .regular)
    }
    
}
