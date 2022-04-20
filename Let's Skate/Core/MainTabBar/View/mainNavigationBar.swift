//
//  mainNavigationBar.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 17/04/2022.
//

import UIKit

class mainNavigationBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        var vcs: [UINavigationController] = []
        TabBarModel.allCases.forEach { item in
            let vc = UINavigationController(rootViewController: item.viewController)
            vc.tabBarItem.image = UIImage(systemName: item.iconName)
            vc.title = item.title
            vcs.append(vc)
        }
        setViewControllers(vcs, animated: true)
        tabBar.tintColor = .label
    }
    
}
