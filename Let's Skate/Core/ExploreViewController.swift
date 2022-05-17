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
    
    private let exploreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 3.5, height: UIScreen.main.bounds.height/4-30)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor().DarkMainColor()
        return collectionView
    }()

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
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "globe"), style: .plain, target: self, action: nil)
    }
    
    private func setupSubviews() {
        view.addSubview(exploreCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        exploreCollectionView.frame = view.bounds
    }
    
    private func setupCollectionView() {
        exploreCollectionView.delegate = self
        exploreCollectionView.dataSource = self
    }
    
    // MARK: - Network Manager calls
    
    private func fetchExplorePosts() {
        viewModel.fetchAllPosts()
    }


}
// MARK: - Extensions
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else { return UICollectionViewCell() }
        guard !posts.isEmpty else { return cell}
        let currentPost = posts[indexPath.row]
        cell.configure(postUrl: currentPost.postUrl)
        cell.backgroundColor = UIColor().lightMainColor()
        return cell
    }
}

extension ExploreViewController: ExploreViewModelOutPut {
    func displayError(error: Error) {
        AlertManager().showErrorAlert(viewcontroller: self, error: error.localizedDescription)
    }
    
    func setExplorePosts(posts: [Post]) {
        self.posts = posts
        DispatchQueue.main.async {
            self.exploreCollectionView.reloadData()
        }
    }
}
