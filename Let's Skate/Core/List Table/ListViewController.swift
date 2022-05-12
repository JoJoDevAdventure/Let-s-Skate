//
//  ListViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 12/05/2022.
//

import UIKit

class ListViewController: UIViewController {
    
    // MARK: - Properties
    
    var users: [User] = []
    
    private let tableViewList: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor().lightMainColor()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        return tableView
    }()

    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupTableView()
        
    }
    
    // MARK: - Set up
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = UIColor().DarkMainColor()
        navigationController?.navigationBar.barTintColor = UIColor().DarkMainColor()
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 31, weight: UIFont.Weight.bold) ]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold) ]
    }
    
    private func setupSubviews() {
        view.addSubview(tableViewList)
    }
    
    private func setupTableView() {
        tableViewList.delegate = self
        tableViewList.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        tableViewList.frame = CGRect(x: 0, y: 50, width: view.bounds.width, height: view.bounds.height - 50)
    }
    
    // MARK: - Network Manager calls
    
    // MARK: - Functions
    
}
// MARK: - Extensions
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        if !users.isEmpty {
            cell.user = users[indexPath.row]
            cell.configure()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
