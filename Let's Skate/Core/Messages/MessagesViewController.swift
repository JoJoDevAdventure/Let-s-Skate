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
        tableView.isHidden = true
        return tableView
    }()
    
    private let noConversationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversations!"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    // MARK: - View Model
    let viewModel: MessagingViewModel
    
    init(viewModel: MessagingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().DarkMainColor()
        setupNavBar()
        setupSubviews()
        setupTableView()
        setupConversations()
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
    
    private func setupConversations() {
        
    }
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
