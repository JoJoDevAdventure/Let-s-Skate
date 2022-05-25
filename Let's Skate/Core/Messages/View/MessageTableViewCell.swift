//
//  MessageTableViewCell.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 25/05/2022.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private let profileImage: ProfileRoundedImageView = {
        let image = ProfileRoundedImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        image.layer.borderColor = UIColor().lightMainColor().cgColor
        return image
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "xxxxxxx xxxxx"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@xxxxxxx"
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = .white
        return label
    }()
    // MARK: - View Model
    
    
    // MARK: - Life cycle
    static let identifier = "MessageTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor().DarkMainColor()
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up
    private func setupSubviews() {
        addSubview(profileImage)
        addSubview(nickNameLabel)
        addSubview(usernameLabel)
    }
    
    private func setupConstraints() {
        let constraints = [
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 50),
            profileImage.heightAnchor.constraint(equalToConstant: 50),
            
            nickNameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 15),
            nickNameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            
            usernameLabel.leftAnchor.constraint(equalTo: nickNameLabel.rightAnchor, constant: 15),
            usernameLabel.centerYAnchor.constraint(equalTo: nickNameLabel.centerYAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Functions
    
    
}
