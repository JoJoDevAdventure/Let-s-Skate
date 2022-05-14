//
//  FeedTableViewCell.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 17/04/2022.
//

import UIKit
import SDWebImage

protocol FeedTableViewCellDelegate: AnyObject {
    
    func FeedTableViewCellShowProfile(user: User)
    func FeedTableViewCellDidTapLike()
    func FeedTableViewCellDidTapComment(post: Post)
    func FeedTableViewCellDidTapShare()
    func FeedTableViewCellDidTapSeeMore()
    
}

class FeedTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var post: Post?
    
    weak var delegate: FeedTableViewCellDelegate?
    
    static let identifier = "FeedTableViewCell"
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "xxxxxxxxxxxxxxxxx"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.textColor = .black
        return label
    }()
    
    private let profileImageView = ProfileRoundedImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
    private let feedPost: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .gray
        return image
    }()
    
    private let likeButton: UnderFeedButton = {
        let button = UnderFeedButton()
        button.setupButton(with: "heart")
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let shareButton: UnderFeedButton = {
        let button = UnderFeedButton()
        button.setupButton(with: "paperplane")
        return button
    }()
    
    private let commentButton: UnderFeedButton = {
        let button = UnderFeedButton()
        button.setupButton(with: "bubble.left")
        return button
    }()
    
    private let moreButton: UnderFeedButton = {
        let button = UnderFeedButton()
        button.setupButton(with: "ellipsis")
        return button
    }()
    
    private let descriptionLabel: UITextView = {
        let label = UITextView()
        label.isEditable = false
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "xxxxxxxxxxxxxxxx xxxx xxxxxx xxxx  xxx xx xxxxxxxx xxxxxxxxx xx xx xxxxxxx xxxx xxxxxxxx xxx xxxxxx xxx xx xxxxxxx xxxxxxxx xx xxxxxxx x xxxxx xxx x xxx x xxxxxxxxxx xxxxxxxx xxxxxxxxx xx xx xxxxxxx xxxx xxxxxxxx xxx xxxxxx xxx xx xxxxxxx xxxxxxxx xx xxxxxxx x xxxxx xxx x xxx x xxxxxxxxx x xxxxxxxx xxxxxxxxx xx xx xxxxxxx xxxx xxxxxxxx xxx xxxxxx xxx xx xxxxxxx xxxxxxxx xx xxxxxxx x xxxxx xxx x xxx x xxxxxxxxx"
        label.accessibilityScroll(.down)
        label.backgroundColor = UIColor().lightMainColor()
        label.textColor = .black
        label.isScrollEnabled = true
        
        return label
    }()
    
    // MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        backgroundColor = UIColor().lightMainColor()
        setupActions()
        setupGestures()
        setupSubViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Set up
    
    private func setupSubViews() {
        addSubview(feedPost)
        addSubview(profileImageView)
        addSubview(nickNameLabel)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        addSubview(moreButton)
        addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        let profileImageConstraint = [
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            profileImageView.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(profileImageConstraint)
        
        let postImageConstraints = [
            feedPost.leadingAnchor.constraint(equalTo: leadingAnchor),
            feedPost.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -30),
            feedPost.trailingAnchor.constraint(equalTo: trailingAnchor),
            feedPost.heightAnchor.constraint(equalToConstant: 400)
        ]
        NSLayoutConstraint.activate(postImageConstraints)
        
        let nicknameLabelConstraints = [
            nickNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nickNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(nicknameLabelConstraints)
        
        let likeButtonConstraints = [
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            likeButton.topAnchor.constraint(equalTo: feedPost.bottomAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(likeButtonConstraints)
        
        let commentButtonConstraints = [
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 20),
            commentButton.topAnchor.constraint(equalTo: likeButton.topAnchor)
        ]
        NSLayoutConstraint.activate(commentButtonConstraints)
        
        let shareButtonConstraints = [
            shareButton.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 20),
            shareButton.topAnchor.constraint(equalTo: likeButton.topAnchor)
        ]
        NSLayoutConstraint.activate(shareButtonConstraints)
        
        let moreButtonConstraints = [
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            moreButton.topAnchor.constraint(equalTo: likeButton.topAnchor, constant: 5)
        ]
        NSLayoutConstraint.activate(moreButtonConstraints)
        
        let descriptionLabelConstraints = [
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -15),
            descriptionLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 10),
        ]
        NSLayoutConstraint.activate(descriptionLabelConstraints)
        
    }
    
    private func setupActions() {
        likeButton.addAction(UIAction(handler: {[weak self] _ in
            self?.delegate?.FeedTableViewCellDidTapLike()
        }), for: .touchUpInside)
        
        commentButton.addAction(UIAction(handler: {[weak self] _ in
            guard let post = self?.post else {
                return
            }
            self?.delegate?.FeedTableViewCellDidTapComment(post: post)
        }), for: .touchUpInside)
        
        shareButton.addAction(UIAction(handler: {[weak self] _ in
            self?.delegate?.FeedTableViewCellDidTapShare()
        }), for: .touchUpInside)
        
        moreButton.addAction(UIAction(handler: {[weak self] _ in
            self?.delegate?.FeedTableViewCellDidTapSeeMore()
        }), for: .touchUpInside)
    }
    
    private func setupGestures() {
        let showProfileTap = UITapGestureRecognizer(target: self, action: #selector(didTapProfile))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(showProfileTap)
        nickNameLabel.isUserInteractionEnabled = true
        nickNameLabel.addGestureRecognizer(showProfileTap)
    }

    
    @objc func didTapProfile() {
        guard let user = post?.user else { return }
        delegate?.FeedTableViewCellShowProfile(user: user)
    }
    
    // MARK: - Functions
    
    func configure() {
        guard let post = post else {
            return
        }
        let nickname = post.user?.nickname == "" ? post.user?.username : post.user?.nickname
        nickNameLabel.text = nickname
        if let url = post.user?.profileImageUrl {
            profileImageView.sd_setImage(with: URL(string: url))
        }
        feedPost.sd_setImage(with: URL(string: post.postUrl))
        descriptionLabel.text = post.bio
    }

}
