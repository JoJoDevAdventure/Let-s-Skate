//
//  ProfileViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 16/04/2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private var currentUserUid: String?
    private var user: User?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 6, height: UIScreen.main.bounds.height/5)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 9
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height/3)*2 - 180)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor().lightMainColor()
        collection.register(ProfileHeaderCollectionReusableView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        return collection
    }()
    
    let viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.currentUserUid = viewModel.userService.getCurrentUser()
        viewModel.output = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().DarkMainColor()
        fetchCurrentInformations()
        setupSubviews()
        setupCollectionView()
    }
    
    // MARK: - Set up
    
    private func setupSubviews() {
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.height - 100)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Functions
    
    private func fetchCurrentInformations() {
        self.viewModel.getUserInformations()
    }
    
}
// MARK: - Extensions
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .gray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader :
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier, for: indexPath)
            guard let ProfileHeaderView = headerView as? ProfileHeaderCollectionReusableView else { return headerView }
            guard let user = user else { return ProfileHeaderView}
            ProfileHeaderView.user = user
            if let currentUid = currentUserUid {
                ProfileHeaderView.setupButtons(userUid: user.id!, currentUserUid: currentUid)
            }
            ProfileHeaderView.delegate = self
            ProfileHeaderView.configure()
            return ProfileHeaderView
        default:
            return UICollectionReusableView()
        }
    }
}

extension ProfileViewController: ProfileViewModelOutPut {
    func setUserInformations(user: User) {
        self.user = user
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showError(Error: Error) {
        print("ERROR")
    }
}

extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
    func didTapEditProfile(user: User) {
        print("DEBUG: EDIT PROFILE")
    }
    
    func didTapNewPost(user: User) {
        print("DEBUG: NEW POST")
    }
    
    func didTapMessage(user: User) {
        print("DEBUG: SEND MESSAGE")
    }
    
    func didTapSubUnsub(user: User) {
        print("DEBUG: SUB UNSUB")
    }
}
