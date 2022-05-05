//
//  ProfileHeaderCollectionReusableView.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 21/04/2022.
//

import UIKit
import SDWebImage

class ProfileHeaderCollectionReusableView: UICollectionReusableView {

    // MARK: - Properties
    
    static let identifier = "ProfileHeaderCollectionReusableView"

    // MARK: - Properties
    
    //banner
    private let bannerImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        
        return image
    }()
    
    //profile Image
    private let profileImage = ProfileRoundedImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
    //full name : Bold
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "xxxxxxx xxxxx"
        label.textColor = .black
        return label
    }()
    
    //Username : Light
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@xxxxxx xxxx"
        label.textColor = .black
        return label
    }()
    
    //Bio : Regular
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "xxxx xxx xxxxxx x x xxxxx xxxx x xxxxxx xx xxx xxxx xxxxxxx xxxx xxx x xxx xxxxxxx xx xx xx xxxxx xxxx xxxxxxxxxxx xxxxxxx xxxx xxx x xxx xxxxxxx xx xx xx xxxxx xxxx xxxxxxxxxxx xxxxxxx xxxx xxx x xxx xxxxxxx xx xx xx xxxxx xxxx xxxxxxxxxxx."
        label.numberOfLines = 3
        label.textColor = .black
        return label
    }()
    
    // edit profile (my account) / Subscribe (others account)
    private let editProfileOrSubButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor().DarkMainColor().cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor().DarkMainColor(), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 0.3
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        return button
    }()
    
    // post new photo (my account) / send message (other account)
    private let messageOrPostPhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("New Post", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor().DarkMainColor().cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor().DarkMainColor(), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 0.3
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        return button
    }()
    
    // posts text
    private let postsLabel: UILabel = {
        let label = UILabel()
        label.text = "Posts"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor().lightMainColor()
        label.backgroundColor = UIColor().DarkMainColor()
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    // posts count button
    private let postsCountButton: UIButton = {
        let button = UIButton()

        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.setTitle("24", for: .normal)
        return button
    }()
    
    // followers text
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "Followers"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor().lightMainColor()
        label.backgroundColor = UIColor().DarkMainColor()
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    // followers count
    private let followersCountButton: UIButton = {
        let button = UIButton()
        button.setTitle("1M", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        return button
    }()
    
    // following text
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.text = "Following"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor().lightMainColor()
        label.backgroundColor = UIColor().DarkMainColor()
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    // following count
    private let followingCountButton: UIButton = {
        let button = UIButton()
        button.setTitle("1044", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        return button
    }()
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Set up
    
    private func setupSubViews() {
        addSubview(bannerImage)
        addSubview(profileImage)
        addSubview(fullNameLabel)
        addSubview(usernameLabel)
        addSubview(bioLabel)
        addSubview(editProfileOrSubButton)
        addSubview(messageOrPostPhotoButton)
        addSubview(postsLabel)
        addSubview(postsCountButton)
        addSubview(followersLabel)
        addSubview(followersCountButton)
        addSubview(followingLabel)
        addSubview(followingCountButton)
    }
    
    private func setupConstraints() {
        let bannerConstraints = [
            bannerImage.topAnchor.constraint(equalTo: topAnchor, constant: -40),
            bannerImage.rightAnchor.constraint(equalTo: rightAnchor),
            bannerImage.leftAnchor.constraint(equalTo: leftAnchor),
            bannerImage.heightAnchor.constraint(equalTo: heightAnchor, constant: -(((bounds.height)/3)*2)+50)
        ]
        NSLayoutConstraint.activate(bannerConstraints)
        
        let profileImageConstraints = [
            profileImage.topAnchor.constraint(equalTo: bannerImage.bottomAnchor, constant: -40),
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            profileImage.heightAnchor.constraint(equalToConstant: 80),
            profileImage.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(profileImageConstraints)
        
        let fullnameConstraints = [
            fullNameLabel.topAnchor.constraint(equalTo: bannerImage.bottomAnchor, constant: 5),
            fullNameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(fullnameConstraints)
        
        let usernameConstraints = [
            usernameLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 2),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(usernameConstraints)
        
        let bioConstraints = [
            bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 6),
            bioLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            bioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ]
        NSLayoutConstraint.activate(bioConstraints)
        
        let editProfileOrSubConstraints = [
            editProfileOrSubButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            editProfileOrSubButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -90),
            editProfileOrSubButton.widthAnchor.constraint(equalToConstant: 150),
            editProfileOrSubButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(editProfileOrSubConstraints)
        
        let messageOrAddPostConstraints = [
            messageOrPostPhotoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            messageOrPostPhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 90),
            messageOrPostPhotoButton.widthAnchor.constraint(equalToConstant: 150),
            messageOrPostPhotoButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(messageOrAddPostConstraints)
        
        let postsLabelConstraints = [
            postsLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 60),
            postsLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 30),
            postsLabel.widthAnchor.constraint(equalToConstant: 60),
            postsLabel.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(postsLabelConstraints)
        
        let postsCountButtonConstraints = [
            postsCountButton.centerXAnchor.constraint(equalTo: postsLabel.centerXAnchor),
            postsCountButton.topAnchor.constraint(equalTo: postsLabel.bottomAnchor, constant: 5),
            postsCountButton.widthAnchor.constraint(equalToConstant: 50),
            postsCountButton.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(postsCountButtonConstraints)
        
        let followersLabelConstraints = [
            followersLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -20),
            followersLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 30),
            followersLabel.widthAnchor.constraint(equalToConstant: 100),
            followersLabel.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(followersLabelConstraints)
        
        let followersCountButtonConstraints = [
            followersCountButton.centerXAnchor.constraint(equalTo: followersLabel.centerXAnchor),
            followersCountButton.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 5),
            followersCountButton.widthAnchor.constraint(equalToConstant: 90),
            followersCountButton.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(followersCountButtonConstraints)
        
        let followingLabelConstraints = [
            followingLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -60),
            followingLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 30),
            followingLabel.widthAnchor.constraint(equalToConstant: 100),
            followingLabel.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(followingLabelConstraints)
        
        let followeingCountButtonConstraints = [
            followingCountButton.centerXAnchor.constraint(equalTo: followingLabel.centerXAnchor),
            followingCountButton.topAnchor.constraint(equalTo: followingLabel.bottomAnchor, constant: 5),
            followingCountButton.widthAnchor.constraint(equalToConstant: 90),
            followingCountButton.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(followeingCountButtonConstraints)
        
    }
    
    
    // MARK: - Functions
    
    func configure(user: User) {
        bannerImage.sd_setImage(with: URL(string: user.bannerImageUrl))
        profileImage.sd_setImage(with: URL(string: user.profileImageUrl))
        fullNameLabel.text = user.nickname
        usernameLabel.text = user.username
        bioLabel.text = user.bio
    }
}
// MARK: - Extensions
