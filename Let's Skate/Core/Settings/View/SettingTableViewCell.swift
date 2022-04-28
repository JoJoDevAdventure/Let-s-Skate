//
//  SettingTableViewCell.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 21/04/2022.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "SettingTableViewCell"

    private let iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.tintColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 30).isActive = true
        image.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return image
    }()
    
    private let settingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Set up
    
    private func setupSubviews() {
        addSubview(iconImage)
        addSubview(settingLabel)
    }
    
    private func setupConstraints() {
        let iconConstraints = [
            iconImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            iconImage.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        NSLayoutConstraint.activate(iconConstraints)
        
        let labelConstraints = [
            settingLabel.leftAnchor.constraint(equalTo: iconImage.rightAnchor, constant: 15),
            settingLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    // MARK: - Functions
    
    public func configure(with iconImageName: String, title: String ) {
        iconImage.image = UIImage(systemName: iconImageName)
        settingLabel.text = title
    }
    
}
