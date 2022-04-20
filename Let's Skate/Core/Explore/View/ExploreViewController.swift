//
//  ExploreViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 16/04/2022.
//

import UIKit

final class ExploreViewController: UIViewController {

    // MARK: - Properties
    private let exploreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 8, height: UIScreen.main.bounds.height/4)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        return collectionView
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupCollectionView()
        setupNavBar()
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
    
    


}
// MARK: - Extensions
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .systemMint
        return cell
    }
}
