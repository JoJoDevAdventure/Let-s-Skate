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
        return image
    }()
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Set up
    
    private func setupSubViews() {
        addSubview(postImage)
    }
    
    override func layoutSubviews() {
        postImage.frame = bounds
    }
    
    // MARK: - Functions
    
    func configure(postUrl: String) {
        postImage.sd_setImage(with: URL(string: postUrl))
    }
    
    
}
// MARK: - Extensions
