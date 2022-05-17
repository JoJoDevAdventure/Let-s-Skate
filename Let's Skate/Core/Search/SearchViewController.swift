//
//  SearchViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 16/04/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for your skate mate"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private let recentResearchTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchUserTableViewCell.self, forCellReuseIdentifier: SearchUserTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - View Model
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().DarkMainColor()
        setupSubViews()
        setupTableView()
    }
    
    // MARK: - Set up
    
    private func setupSubViews() {
        view.addSubview(recentResearchTableView)
    }
    
    private func setupTableView() {
        recentResearchTableView.backgroundColor = UIColor().DarkMainColor()
        recentResearchTableView.delegate = self
        recentResearchTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        recentResearchTableView.frame = view.bounds
    }
    
    // MARK: - Functions

    
    // MARK: - Network Manager calls

}
// MARK: - Extensions

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchUserTableViewCell.identifier) as? SearchUserTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
