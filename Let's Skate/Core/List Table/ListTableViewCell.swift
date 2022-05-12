//
//  ListTableViewCell.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 12/05/2022.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let profileImage = ProfileRoundedImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    // MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Set up
    
    
    // MARK: - Functions

}
