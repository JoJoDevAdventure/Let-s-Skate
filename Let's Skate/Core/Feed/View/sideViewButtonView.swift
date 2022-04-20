//
//  sideViewButtonView.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 20/04/2022.
//

import UIKit

class sideViewButtonView: UIView {
    
    // MARK: - Properties
    
    private let buttonImage: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let buttonText: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

    
    // MARK: - Set up
    
    private func setupSubviews() {
        addSubview(buttonImage)
        addSubview(buttonText)
    }
    
    private func setupConstraints() {
        
        let imageConstraints = [
            buttonImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonImage.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -2)
        ]
        NSLayoutConstraint.activate(imageConstraints)
        
        let textConstraints = [
            buttonText.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonText.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 2)
        ]
        NSLayoutConstraint.activate(textConstraints)
        
    }

}
