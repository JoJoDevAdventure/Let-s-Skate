//
//  ListTableViewCell.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 12/05/2022.
//

import UIKit
import SDWebImage

class ListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ListTableViewCell"
    
    var user: User?
    
    private let profileImage = ProfileRoundedImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    // MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
        backgroundColor = UIColor().lightMainColor()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Set up
    
    private func setupSubviews() {
        addSubview(profileImage)
        addSubview(nicknameLabel)
        addSubview(usernameLabel)
    }
    
    private func setupConstraints() {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            
            //profile image constraints
            profileImage.widthAnchor.constraint(equalToConstant: 60),
            profileImage.heightAnchor.constraint(equalToConstant: 60),
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            //nickname label
            nicknameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
            nicknameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            //username label
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            usernameLabel.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: 10),
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Functions

    func configure() {
        guard let user = user else {
            return
        }
        profileImage.sd_setImage(with: URL(string: user.profileImageUrl))
        nicknameLabel.text = user.nickname
        usernameLabel.text = user.username
    }
}
