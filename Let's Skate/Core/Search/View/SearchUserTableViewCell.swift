//
//  SearchUserTableViewCell.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 17/05/2022.
//

import UIKit
import SDWebImage

class SearchUserTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "SearchUserTableViewCell"

    private let cellBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor().lightMainColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 7
        view.alpha = 0.8
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    private let profileImageView: ProfileRoundedImageView = {
        let image = ProfileRoundedImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        image.backgroundColor = .gray
        return image
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "XXXXXXXXXXXXX"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.text = "@XXXXXXXXXX"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - View Model
    
    
    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor().DarkMainColor()
        selectionStyle = .none
        setupSubViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Set up
    private func setupSubViews() {
        addSubview(cellBackGroundView)
        addSubview(profileImageView)
        addSubview(nickNameLabel)
        addSubview(usernameLabel)
    }
    
    private func setupConstraints() {
        let constraints = [
            //background
            cellBackGroundView.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            cellBackGroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: 7),
            cellBackGroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: -7),
            cellBackGroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            
            //profile image
            profileImageView.centerYAnchor.constraint(equalTo: cellBackGroundView.centerYAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.leftAnchor.constraint(equalTo: cellBackGroundView.leftAnchor, constant: 15),
        
            //nickname Label
            nickNameLabel.centerYAnchor.constraint(equalTo: cellBackGroundView.centerYAnchor, constant: -15),
            nickNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10),
            
            //username Label
            usernameLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 5),
            usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    // MARK: - Functions

    func configure(user: User) {
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl))
        nickNameLabel.text = user.nickname
        usernameLabel.text = user.username
    }
    
    // MARK: - Extensions
    
}
