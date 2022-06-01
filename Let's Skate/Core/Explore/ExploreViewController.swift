//
//  ExploreViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 16/04/2022.
//

import UIKit

final class ExploreViewController: UIViewController {

    // MARK: - Properties
    var posts : [Post] = []
    
    // MARK: - UI
    private let exploreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout().exploreLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.registerCell(PostCollectionViewCell.self)
        collectionView.backgroundColor = UIColor().DarkMainColor()
        collectionView.isHidden = true
        return collectionView
    }()
    
    private let loadingSpinner = LightLoadingAnimation()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().DarkMainColor()
        setupSubviews()
        setupCollectionView()
        setupNavBar()
        fetchExplorePosts()
    }
    
    //MARK: - ViewModel
    let viewModel: ExploreViewModel
    
    init(viewModel: ExploreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.output = self
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up
    
    private func setupNavBar() {
        title = "Explore"
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "globe"), style: .plain, target: self, action: nil)
    }
    // adding subviews
    private func setupSubviews() {
        view.addSubview(exploreCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        exploreCollectionView.frame = view.bounds
    }
    //collection view delegate / datasource
    private func setupCollectionView() {
        exploreCollectionView.delegate = self
        exploreCollectionView.dataSource = self
    }
    
    // MARK: - Network Manager calls
    
    private func fetchExplorePosts() {
        loadingSpinner.show(view: view)
        viewModel.fetchAllPosts()
    }


}
// MARK: - Extensions : CollectionView
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeResuableCell(for: PostCollectionViewCell.self, for: indexPath)
        guard !posts.isEmpty else { return cell}
        let currentPost = posts[indexPath.row]
        cell.configure(postUrl: currentPost.postUrl)
        cell.backgroundColor = UIColor().lightMainColor()
        return cell
    }
}

// MARK: - Extensions : ViewModel Output
extension ExploreViewController: ExploreViewModelOutPut {
    func displayError(error: Error) {
        AlertManager().showErrorAlert(viewcontroller: self, error: error.localizedDescription)
    }
    
    func setExplorePosts(posts: [Post]) {
        self.posts = posts
        
        DispatchQueue.main.async {
            self.loadingSpinner.dismiss()
            self.exploreCollectionView.isHidden = false
            self.exploreCollectionView.reloadData()
        }
    }
}
