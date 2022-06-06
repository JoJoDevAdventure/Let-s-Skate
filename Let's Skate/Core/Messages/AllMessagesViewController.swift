//
//  MessagesViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 16/04/2022.
//

import UIKit

final class AllMessagesViewController: UIViewController {
    
    private var conversation = [User]()
    
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
        label.text = "No Conversations.\nStart a new one!"
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    private let loadingSpinner = LightLoadingAnimation()
    
    // MARK: - View Model
    let viewModel: AllMessagesViewModel
    
    init(viewModel: AllMessagesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.output = self
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
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        feetchConversations()
    }
    // MARK: - Set up
    private func setupNavBar() {
        title = "Messages"
        navigationController?.whiteLargeTitle()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(didTapComposeButton))
    }
    //adding subviews
    private func setupSubviews() {
        view.addSubview(messagesTableView)
        view.addSubview(noConversationsLabel)
    }
    
    //tableView delegate and datasource
    private func setupTableView() {
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        messagesTableView.frame = view.bounds
    }
    
    private func setupConstraints() {
        let constraints = [
            noConversationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noConversationsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Functions
    
    @objc private func didTapComposeButton() {
        Navigation.shared.showNewConversationViewController(from: self)
    }
    
    // MARK: - Network Manager calls
    
    private func feetchConversations() {
        if messagesTableView.isHidden {
            loadingSpinner.show(view: view)
        }
        messagesTableView.isHidden = true
        noConversationsLabel.isHidden = true
        viewModel.fetchAllConversations()
    }
    
}
// MARK: - Extension : TableView
extension AllMessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeResuableCell(for: MessageTableViewCell.self, for: indexPath)
        guard !conversation.isEmpty else { return cell}
        cell.configure(user: conversation[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Navigation.shared.goToChatViewController(from: self, user: conversation[indexPath.row])
    }

}

extension AllMessagesViewController: AllMessagesViewModelOutPut {
    
    func noMessagesWithThisUser() {
        
    }
    
    func fetchedConversations(conversations: [User]) {

        DispatchQueue.main.async {
            self.loadingSpinner.dismiss()
            if conversations.isEmpty {
                self.noConversationsLabel.isHidden = false
            } else {
                self.conversation = conversations
                self.messagesTableView.isHidden = false
                self.messagesTableView.reloadData()
            }
        }
    }
    
    func showError(conversation: Error) {
        AlertManager().showErrorAlert(viewcontroller: self, error: conversation.localizedDescription)
    }
}
