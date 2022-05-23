//
//  ProfileHeaderCollectionReusableView.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 21/04/2022.
//

import UIKit
import SDWebImage

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func didTapEditProfile()
    func didTapNewPost()
    func didTapMessage()
    func didTapSubUnsub()
    func didTapShowFollowers()
    func didTapShowFollowing()
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {

    // MARK: - Properties
    
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    var user: User?
    var currentUserUid: String?
    var currentUser = false

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
        label.textColor = .black
        return label
    }()
    
    //Username : Light
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    //Bio : Regular
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 4
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
        button.isHidden = true
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
        button.isHidden = true
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
        setupObservers()
        setupFollowerFollowing()
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
            bannerImage.widthAnchor.constraint(equalTo: widthAnchor),
            bannerImage.heightAnchor.constraint(equalTo: bannerImage.widthAnchor, multiplier: 0.3 )
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
            editProfileOrSubButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            editProfileOrSubButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -90),
            editProfileOrSubButton.widthAnchor.constraint(equalToConstant: 150),
            editProfileOrSubButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(editProfileOrSubConstraints)
        
        let messageOrAddPostConstraints = [
            messageOrPostPhotoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            messageOrPostPhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 90),
            messageOrPostPhotoButton.widthAnchor.constraint(equalToConstant: 150),
            messageOrPostPhotoButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(messageOrAddPostConstraints)
        
        let postsLabelConstraints = [
            postsLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 60),
            postsLabel.topAnchor.constraint(equalTo: editProfileOrSubButton.topAnchor, constant: -100),
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
            followersLabel.topAnchor.constraint(equalTo: postsLabel.topAnchor),
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
            followingLabel.topAnchor.constraint(equalTo: postsLabel.topAnchor),
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
    
    //setup buttons ui
    func setupButtons() {
        guard let userUid = user?.id else { return }
        guard let currentUserUid = currentUserUid else {
            return
        }
        guard user?.subed != nil else { return }
        guard userUid == currentUserUid else {
            currentUser = false
            notCurrentUserConfiguration()
            return
        }
        isCurrentUserConfiguration()
        currentUser = true
    }
    
    //observer to know buttons actions
    func setupObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("setupButtonsActions"), object: nil, queue: nil) { _ in
            DispatchQueue.main.async {
                self.setupButtonsActions()
            }
        }
    }
    
    // MARK: - Functions
    
    func configure() {
        guard let user = user else {
            return
        }
        bannerImage.sd_setImage(with: URL(string: user.bannerImageUrl))
        profileImage.sd_setImage(with: URL(string: user.profileImageUrl))
        fullNameLabel.text = user.nickname
        usernameLabel.text = user.username
        //mac bio char = 150.
        bioLabel.text = user.bio
        guard let nbPost = user.posts?.count else { return }
        postsCountButton.setTitle("\(nbPost)", for: .normal)
        guard let nbFollowers = user.followers?.count else { return }
        followersCountButton.setTitle("\(nbFollowers)", for: .normal)
        guard let nbFollowing = user.following?.count else { return }
        followingCountButton.setTitle("\(nbFollowing)", for: .normal)
        setupButtons()
    }
    
    private func notCurrentUserConfiguration() {
        guard let isSubed = user?.subed else { return }
        
        messageOrPostPhotoButton.isHidden = false
        editProfileOrSubButton.isHidden = false
        
        //MESSAGE
        messageOrPostPhotoButton.setTitle("Message", for: .normal)
        
        if isSubed {
            //FOLLOW
            editProfileOrSubButton.setTitle("UnFollow", for: .normal)
            editProfileOrSubButton.setTitleColor(UIColor().DarkMainColor(), for: .normal)
            editProfileOrSubButton.backgroundColor = UIColor().lightMainColor()
            editProfileOrSubButton.layer.borderColor = UIColor().DarkMainColor().cgColor
            editProfileOrSubButton.layer.borderWidth = 2
        } else {
            //UNFOLLOW
            editProfileOrSubButton.setTitle("Follow", for: .normal)
            editProfileOrSubButton.setTitleColor(.white, for: .normal)
            editProfileOrSubButton.backgroundColor = UIColor().DarkMainColor()
            editProfileOrSubButton.layer.borderColor = UIColor.black.cgColor
            editProfileOrSubButton.layer.borderWidth = 1
        }
    
    }
    
    private func isCurrentUserConfiguration() {
        
        messageOrPostPhotoButton.isHidden = false
        editProfileOrSubButton.isHidden = false
        
        //EDIT PROFILE
        editProfileOrSubButton.setTitle("Edit Profile", for: .normal)
        editProfileOrSubButton.setTitleColor(UIColor().DarkMainColor(), for: .normal)
        editProfileOrSubButton.backgroundColor = UIColor().lightMainColor()
        editProfileOrSubButton.layer.borderColor = UIColor().DarkMainColor().cgColor
        editProfileOrSubButton.layer.borderWidth = 2
        editProfileOrSubButton.layer.shadowColor = UIColor.black.cgColor
        editProfileOrSubButton.layer.shadowRadius = 0.3
        editProfileOrSubButton.layer.shadowOpacity = 0.4
        editProfileOrSubButton.layer.shadowOffset = CGSize(width: 1, height: 1)

        //NEW POST
        messageOrPostPhotoButton.setTitle("New Post", for: .normal)

    }
    
    func setupButtonsActions() {
        if currentUser {
            editProfileOrSubButton.addAction(UIAction(handler: { _ in
                self.delegate?.didTapEditProfile()
            }), for: .touchUpInside)
            
            messageOrPostPhotoButton.addAction(UIAction(handler: { _ in
                self.delegate?.didTapNewPost()
            }), for: .touchUpInside)
        } else {
            messageOrPostPhotoButton.addAction(UIAction(handler: { _ in
                self.delegate?.didTapMessage()
            }), for: .touchUpInside)
            
            editProfileOrSubButton.addAction(UIAction(handler: { _ in
                self.delegate?.didTapSubUnsub()
            }), for: .touchUpInside)
        }
    }
    
    private func setupFollowerFollowing() {
        followersCountButton.addAction(UIAction(handler: { _ in
            self.delegate?.didTapShowFollowers()
        }), for: .touchUpInside)
        
        followingCountButton.addAction(UIAction(handler: { _ in
            self.delegate?.didTapShowFollowing()
        }), for: .touchUpInside)
    }
}
// MARK: - Extensions
