//
//  NewConversationViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 01/06/2022.
//

import UIKit

class NewConversationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let spinner = LightLoadingAnimation()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Results"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users ..."
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.registerCell(SearchUserTableViewCell.self)
        return table
    }()
    
    // MARK: - View Model
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().lightMainColor()

        setupNavBar()
    }
    
    // MARK: - Set up
    
    private func setupNavBar() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissSelf))
        searchBar.searchTextField.becomeFirstResponder()
    }
    
    // MARK: - Functions
    
    
    // MARK: - Network Manager calls
    
    
    // MARK: - Extensions
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
}
