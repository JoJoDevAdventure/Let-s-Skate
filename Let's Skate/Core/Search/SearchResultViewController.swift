//
//  SearchResultViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 17/05/2022.
//

import UIKit

protocol SearchResultViewControllerDelegate : AnyObject {
    func didSelectUser(user: User)
}

class SearchResultViewController: UIViewController {
    
    weak var delegate: SearchResultViewControllerDelegate?
    var users: [User] = []
    
    // MARK: - Properties
    let resultResearchTableView: UITableView = {
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
        view.addSubview(resultResearchTableView)
    }
    
    private func setupTableView() {
        resultResearchTableView.backgroundColor = UIColor().DarkMainColor()
        resultResearchTableView.delegate = self
        resultResearchTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        resultResearchTableView.frame = view.bounds
    }
    
    // MARK: - Functions
    

}
// MARK: - Extensions
extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchUserTableViewCell.identifier) as? SearchUserTableViewCell else {
            return UITableViewCell()
        }
        if !users.isEmpty {
            cell.configure(user: users[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //show user profile
        delegate?.didSelectUser(user: users[indexPath.row])
        //save selected user to core data
        // TODO: CoreData
    }
}
