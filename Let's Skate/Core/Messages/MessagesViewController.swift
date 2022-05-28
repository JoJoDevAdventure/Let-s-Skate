//
//  MessagesViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 16/04/2022.
//

import UIKit

final class MessagesViewController: UIViewController {
    
    // MARK: - Properties
    private let messagesTableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(MessageTableViewCell.self)
        tableView.backgroundColor = UIColor().DarkMainColor()
        tableView.separatorColor = UIColor().lightMainColor()
        return tableView
    }()
    
    // MARK: - View Model
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().DarkMainColor()
        setupNavBar()
        setupSubviews()
        setupTableView()
    }
    
    // MARK: - Set up
    private func setupNavBar() {
        title = "Messages"
        navigationController?.whiteLargeTitle()
    }
    //adding subviews
    private func setupSubviews() {
        view.addSubview(messagesTableView)
    }
    
    //tableView delegate and datasource
    private func setupTableView() {
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        messagesTableView.frame = view.bounds
    }
    
    // MARK: - Functions
    
    
    // MARK: - Network Manager calls
    
}
// MARK: - Extension : TableView
extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeResuableCell(for: MessageTableViewCell.self, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
