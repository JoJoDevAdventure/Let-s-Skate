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
        
        return tableView
    }()

    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupTableView()
    }
    
    // MARK: - Set up
    
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
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
