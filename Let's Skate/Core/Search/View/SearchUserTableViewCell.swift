//
//  SearchUserTableViewCell.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 17/05/2022.
//

import UIKit

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
    
    // MARK: - View Model
    
    
    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor().DarkMainColor()
        setupSubViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Set up
    private func setupSubViews() {
        addSubview(cellBackGroundView)
    }
    
    private func setupConstraints() {
        let constraints = [
            cellBackGroundView.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            cellBackGroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: 7),
            cellBackGroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: 7),
            cellBackGroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 7),
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    // MARK: - Functions

    
    
    // MARK: - Extensions
    
}
