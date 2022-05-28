//
//  SideMenuView.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 20/04/2022.
//

import UIKit

protocol SideMenuViewDelegate : AnyObject {
    func SideMenuViewDidTapProfileButton()
    func SideMenuViewDidTapSettingButton()
    func SideMenuViewDidTapLogOut()
}

final class SideMenuView: UIView {
    
    // MARK: - Properties
    weak var delegate: SideMenuViewDelegate?
    
    // MARK: - UI
    private let container: UIView = {
        let container = UIView()
        container.transform = container.transform.rotated(by: -0.01)
        container.backgroundColor = UIColor().DarkMainColor()
        return container
    }()
    
    // Full name
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    // Username
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    // Profile Pic
    private let profilePic = ProfileRoundedImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
    // Go to profile button
    private let profileButton: sideViewButtonView = {
        let button = sideViewButtonView()
        button.configureButton(with: "person", "Profile")
        return button
    }()
    
    // Go to settings button
    private let settingButton: sideViewButtonView = {
        let button = sideViewButtonView()
        button.configureButton(with: "gear", "Settings")
        return button
    }()
    
    // logout
    private let logoutButton: sideViewButtonView = {
        let button = sideViewButtonView()
        button.configureButton(with: "iphone.and.arrow.forward", "Log out")
        return button
    }()
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        setupGestureReconizer()
        backgroundColor = UIColor().DarkMainColor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Set up
    
    // adding subviews
    private func setupSubviews() {
        addSubview(container)
        container.addSubview(fullnameLabel)
        container.addSubview(profilePic)
        container.addSubview(usernameLabel)
        container.addSubview(profileButton)
        container.addSubview(settingButton)
        container.addSubview(logoutButton)
    }
    
    override func layoutSubviews() {
        container.frame = bounds
    }
    
    // Constraints
    private func setupConstraints() {
        let fullNameLabelConstraints = [
            fullnameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -300),
            fullnameLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 70)
        ]
        NSLayoutConstraint.activate(fullNameLabelConstraints)
        
        let usernameConstraints = [
            usernameLabel.centerXAnchor.constraint(equalTo: fullnameLabel.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: fullnameLabel.bottomAnchor, constant: 6)
        ]
        NSLayoutConstraint.activate(usernameConstraints)
        
        let profilePicConstraints = [
            profilePic.centerXAnchor.constraint(equalTo: fullnameLabel.centerXAnchor),
            profilePic.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
            profilePic.heightAnchor.constraint(equalToConstant: 80),
            profilePic.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(profilePicConstraints)
        
        let profileButtonConstraints = [
            profileButton.centerXAnchor.constraint(equalTo: fullnameLabel.centerXAnchor),
            profileButton.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 40),
            profileButton.widthAnchor.constraint(equalToConstant: 200),
            profileButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(profileButtonConstraints)
        
        let settingButtonConstraints = [
            settingButton.centerXAnchor.constraint(equalTo: fullnameLabel.centerXAnchor),
            settingButton.topAnchor.constraint(equalTo: profileButton.bottomAnchor, constant: 20),
            settingButton.widthAnchor.constraint(equalToConstant: 200),
            settingButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(settingButtonConstraints)
        
        let logoutButtonConstraints = [
            logoutButton.centerXAnchor.constraint(equalTo: fullnameLabel.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: settingButton.bottomAnchor, constant: 20),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(logoutButtonConstraints)
    }
    
    // setup Gesture Reconizers
    private func setupGestureReconizer() {
        profileButton.isUserInteractionEnabled = true
        profileButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProfileButton)))
        settingButton.isUserInteractionEnabled = true
        settingButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSettingButton)))
        logoutButton.isUserInteractionEnabled = true
        logoutButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLogoutButton)))
    }
    
    // MARK: - Functions
    
    // show side menu
    public func sideMenuDidApear() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {[weak self] in
            self?.profileButton.alpha = 1
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {[weak self] in
            self?.settingButton.alpha = 1
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {[weak self] in
            self?.logoutButton.alpha = 1
        }
    }
    
    // hide side menu
    public func sideMenuDisapear() {
        profileButton.alpha = 0
        settingButton.alpha = 0
        logoutButton.alpha = 0
    }
    
    /// Delegate to FeedViewContoller
    // profile button
    @objc func didTapProfileButton() {
        delegate?.SideMenuViewDidTapProfileButton()
    }
    
    // settings button
    @objc func didTapSettingButton() {
        delegate?.SideMenuViewDidTapSettingButton()
    }
    
    // Log out
    @objc func didTapLogoutButton() {
        delegate?.SideMenuViewDidTapLogOut()
    }
    
    // configure with real user data
    func configure(profileImage: UIImage, username: String, nickname: String) {
        profilePic.image = profileImage
        fullnameLabel.text = nickname
        usernameLabel.text = "\(username)"
    }

}
