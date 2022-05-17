//
//  SearchViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 16/04/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for your skate mate"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private let recentResearchViewController: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultViewController.self, forCellReuseIdentifier: <#T##String#>)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().DarkMainColor()
    }

}
