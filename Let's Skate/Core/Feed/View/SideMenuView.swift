//
//  SideMenuView.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 20/04/2022.
//

import UIKit

class SideMenuView: UIView {
    
    // MARK: - Properties
    private let container: UIView = {
        let container = UIView()
        container.transform = container.transform.rotated(by: -0.01)
        container.backgroundColor = .label
        return container
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Joseph Bhl"
        label.textColor = .systemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.text = "@youssefbhl2727"
        label.textColor = .systemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profilePic = ProfileRoundedImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        backgroundColor = .label
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Set up
    
    private func setupSubviews() {
        addSubview(container)
        container.addSubview(fullnameLabel)
        container.addSubview(profilePic)
        container.addSubview(usernameLabel)
    }
    
    override func layoutSubviews() {
        container.frame = bounds
    }
    
    private func setupConstraints() {
        let fullNameLabelConstraints = [
            fullnameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -680),
            fullnameLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 70)
        ]
        NSLayoutConstraint.activate(fullNameLabelConstraints)
        
        let usernameConstraints = [
            usernameLabel.centerXAnchor.constraint(equalTo: fullnameLabel.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: fullnameLabel.bottomAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(usernameConstraints)
        
        let profilePicConstraints = [
            profilePic.centerXAnchor.constraint(equalTo: fullnameLabel.centerXAnchor),
            profilePic.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
            profilePic.heightAnchor.constraint(equalToConstant: 80),
            profilePic.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(profilePicConstraints)
        

    }
    
    // MARK: - Functions
    

    
    // MARK: - Extensions
    

}
