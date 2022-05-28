//
//  CustomSeachViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 28/05/2022.
//

import UIKit

class CustomSeachViewController: UISearchController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Tonny Hawks...", attributes: [NSAttributedString.Key.foregroundColor: UIColor().DarkMainColor()])
        searchBar.searchTextField.backgroundColor = UIColor().lightMainColor()
        searchBar.searchTextField.leftView?.tintColor = UIColor().DarkMainColor()
        searchBar.searchBarStyle = .minimal
    }

}
