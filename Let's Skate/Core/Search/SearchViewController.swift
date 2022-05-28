//
//  SearchViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 16/04/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    var users: [User] = []
    
    // MARK: - UI
    private let searchController = CustomSeachViewController(searchResultsController: SearchResultViewController())
    
    private let recentResearchTableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(SearchUserTableViewCell.self)
        return tableView
    }()
    
    // MARK: - View Model
    let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
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
        setupSubViews()
        setupTableView()
        setupNavBar()
    }
    
    // MARK: - Set up
    
    private func setupNavBar() {
        title = "Search for mates"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        navigationController?.whiteLargeTitle()
    }
    
    //adding subviews
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

// MARK: - Extension : TableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeResuableCell(for: SearchUserTableViewCell.self, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

// MARK: - Extension : UISearchResult
extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchbar = searchController.searchBar
        guard let query = searchbar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {
                  return
              }
        resultsController.delegate = self
        viewModel.seachUserWithUserName(username: query)
        resultsController.users = self.users
        DispatchQueue.main.async {
            resultsController.resultResearchTableView.reloadData()
        }
        
    }
}

// MARK: - Extension : ViewModel output
extension SearchViewController: searchViewModelOutPut {
    
    func updateUsers(users: [User]) {
        self.users = users
    }
    
    func showError(error: Error) {
        AlertManager().showErrorAlert(viewcontroller: self, error: error.localizedDescription)
    }
    
}

// MARK: - Extension: SearchResult Delegate
extension SearchViewController: SearchResultViewControllerDelegate {
    func didSelectUser(user: User) {
        let imageUploader : ImageUploader = StorageManager()
        let postsService : ProfilePostsService = PostsManager(imageUploaderService: imageUploader)
        let userService : ProfileUserService = UserManager()
        let viewModel = ProfileViewModel(user: user, userService: userService, postsService: postsService)
        let vc = ProfileViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
