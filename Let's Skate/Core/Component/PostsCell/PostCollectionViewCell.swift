//
//  PostCollectionViewCell.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 19/04/2022.
//

import UIKit
import SDWebImage

class PostCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let identifier = "PostCollectionViewCell"
    
    private let postImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        setupConstraints()
        backgroundColor = UIColor().DarkMainColor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Set up
    
    private func setupSubViews() {
        addSubview(postImage)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            postImage.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            postImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 2),
            postImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -2),
            postImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
        ])
    }
    
    // MARK: - Functions
    
    func configure(postUrl: String) {
        postImage.sd_setImage(with: URL(string: postUrl))
    }
    
    
}
// MARK: - Extensions
