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
        let image = ProfileRoundedImageView(frame: CGRect(x: 0, y: 0, width: 55, height: 55))
        image.layer.borderColor = UIColor().lightMainColor().cgColor
        return image
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "xxxxxxx xxxxx"
        label.font = .systemFont(ofSize: 26, weight: .semibold)
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
    
    private let arrowCell: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "chevron.right")
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        return image
    }()
    // MARK: - View Model
    
    
    // MARK: - Life cycle
    static let identifier = "MessageTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor().DarkMainColor()
        selectionStyle = .none
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
        addSubview(arrowCell)
    }
    
    private func setupConstraints() {
        let constraints = [
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 55),
            profileImage.heightAnchor.constraint(equalToConstant: 55),
            
            nickNameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 15),
            nickNameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            
            usernameLabel.leftAnchor.constraint(equalTo: nickNameLabel.rightAnchor, constant: 15),
            usernameLabel.centerYAnchor.constraint(equalTo: nickNameLabel.centerYAnchor),
            
            arrowCell.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowCell.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            arrowCell.widthAnchor.constraint(equalToConstant: 25),
            arrowCell.heightAnchor.constraint(equalToConstant: 25),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Functions
    
    
}
