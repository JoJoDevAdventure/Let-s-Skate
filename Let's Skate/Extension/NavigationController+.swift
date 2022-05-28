//
//  NavigationController+.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 28/05/2022.
//

import Foundation
import UIKit

extension UINavigationController {
    func whiteLargeTitle() {
        self.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationBar.tintColor = .white
        self.navigationBar.backgroundColor = UIColor().DarkMainColor()
        self.navigationBar.barTintColor = UIColor().DarkMainColor()
        self.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 31, weight: UIFont.Weight.bold) ]
        self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold) ]
    }
}
