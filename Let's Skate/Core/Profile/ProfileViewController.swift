//
//  ProfileViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 16/04/2022.
//

import UIKit
import Lottie

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private var currentUserUid: String?
    private var user: User
    
    // inital collectionview + Header
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
        collection.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)

        return collection
    }()
    
    private let loadingAnimation: AnimationView = {
        let animationView = AnimationView()
        animationView.animation = Animation.named("darkLoadingView")
        animationView.contentMode = .scaleAspectFill
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        animationView.loopMode = .loop
        return animationView
    }()
    
    // MARK: - ViewModel
    
    let viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        self.currentUserUid = viewModel.userService.getCurrentUser()
        self.user = viewModel.user
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
        self.viewModel.fetchUserInformations()
    }
    
    private func deleteItemAt(_ indexPath: IndexPath) {
        guard let posts = user.posts else { return }
        let post = posts[indexPath.row]
        viewModel.deletePost(post: post)
    }
    
}
// MARK: - Extensions : CollectionView
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else { return UICollectionViewCell() }
        if let posts = user.posts {
            let postUrl = posts[indexPath.row].postUrl
            cell.configure(postUrl: postUrl)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader :
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier, for: indexPath)
            guard let ProfileHeaderView = headerView as? ProfileHeaderCollectionReusableView else { return headerView }
            ProfileHeaderView.user = user
            guard let currentID = self.currentUserUid else { return headerView }
            ProfileHeaderView.currentUserUid = currentID
            ProfileHeaderView.configure()
            ProfileHeaderView.delegate = self
            return ProfileHeaderView
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let currentUserUid = currentUserUid else { return nil}
        guard let userId = user.id else { return nil }
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let seePostAction = UIAction(title: "See post", image: UIImage(systemName: "eye"), state: .off) { _ in
                print("DEBUG : SEE POST")
            }
            if currentUserUid == userId {
                let deleteAction = UIAction(title: "Delete Post", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.deleteItemAt(indexPath)
                }
                deleteAction.image?.withTintColor(.systemRed)
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [deleteAction, seePostAction])
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [seePostAction])
        }
        return config
    }
}

// MARK: - Extensions : viewModel output
extension ProfileViewController: ProfileViewModelOutPut {
    
    func showItemDeletionAnimation() {
        view.addSubview(loadingAnimation)
        loadingAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingAnimation.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingAnimation.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loadingAnimation.removeFromSuperview()
        }
    }
    
    
    func setButtons() {
        NotificationCenter.default.post(name: NSNotification.Name("setupButtonsActions"), object: nil)
    }
    
    
    func subedUnsubed(user: User) {
        self.user = user
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
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

// MARK: - Extensions : Header  Delegate
extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
    func didTapShowFollowers() {
        let vc = ListViewController()
        vc.title = "Followers"
        guard let followers = user.followers else { return }
        vc.users = followers
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapShowFollowing() {
        let vc = ListViewController()
        vc.title = "Followers"
        guard let following = user.following else { return }
        vc.users = following
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapEditProfile() {
        print("EDIT")
        collectionView.reloadData()
    }
    
    func didTapNewPost() {
        print("POST")
    }
    
    func didTapMessage() {
        print("MESSAGE")
    }
    
    func didTapSubUnsub() {
        viewModel.subUnsubToUser()
    }
}
