//
//  FeedViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 16/04/2022.
//

import UIKit
import SDWebImage

final class FeedViewController: UIViewController {
    
    // MARK: - Properties
    
    var NavBarProfileImage = UIImage(named: "black")
    var posts: [Post] = []
    
    // MARK: - UI
    
    private let noPostsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No posts yet.\nTry to follow some peoples!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let feedTableView: UITableView = {
        let table = UITableView()
        table.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        table.isUserInteractionEnabled = true
        table.allowsSelectionDuringEditing = true
        table.backgroundColor = UIColor().DarkMainColor()
        return table
    }()
    
    private let addPostButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.tintColor = .white
        button.setImage(image, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.backgroundColor = UIColor().DarkMainColor()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 35
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 0.5
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.isHidden = false
        return button
    }()
    
    private let unfocusView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.cgColor
        layer.opacity = 0.5
        view.layer.addSublayer(layer)
        view.layer.opacity = 1
        return UIView()
    }()
    
    private let sideMenu = SideMenuView(frame: CGRect(x: -UIScreen.main.bounds.width, y: -100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*2))
    
    // MARK: - ViewModel
    
    private let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
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
        setupSideMenu()
        sideViewDelegate()
        fetchCurrentUser()
        setupAddButton()
        fetchPosts()
        checkIfThereArePosts()
        setupObserver()
    }

    // MARK: - Set up
    private func setupSubViews() {
        view.addSubview(addPostButton)
        view.addSubview(noPostsLabel)
        noPostsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noPostsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        view.addSubview(feedTableView)
        view.addSubview(addPostButton)
        addPostButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addPostButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }
    
    private func setupProfileImage() {
        NavBarProfileImage = NavBarProfileImage?.withRenderingMode(.alwaysOriginal)
        NavBarProfileImage = NavBarProfileImage?.sd_resizedImage(with: CGSize(width: 40, height: 40), scaleMode: .aspectFill)
        NavBarProfileImage = NavBarProfileImage?.sd_roundedCornerImage(withRadius: 20, corners: .allCorners, borderWidth: 0, borderColor: .clear)
    }
    
    private func setupNavBar() {
        title = "Skater's Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = UIColor().DarkMainColor()
        navigationController?.navigationBar.barTintColor = UIColor().DarkMainColor()
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 31, weight: UIFont.Weight.bold) ]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold) ]
        setupProfileImage()
        NavBarProfileImage = NavBarProfileImage?.withRenderingMode(.alwaysOriginal)
        NavBarProfileImage?.withTintColor(UIColor().lightMainColor())
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: NavBarProfileImage, style: .plain, target: self, action: #selector(didTapProfileImage))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        feedTableView.frame = CGRect(x: 0, y: 70, width: view.frame.width, height: view.frame.height - 70)
        unfocusView.frame = view.bounds
    }
    
    private func setupTableView() {
        feedTableView.delegate = self
        feedTableView.dataSource = self
    }
    
    private func setupSideMenu() {
        unfocusView.isUserInteractionEnabled = true
        unfocusView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLeave)))
    }
    
    private func sideViewDelegate() {
        sideMenu.delegate = self
    }
    
    private func setupAddButton() {
        addPostButton.addAction(UIAction(handler: { _ in
            let imageUploadService: ImageUploader = StorageManager()
            let service: NewPostService = PostsManager(imageUploaderService: imageUploadService)
            let viewModel = NewPostViewModel(postsService: service)
            let vc = AddNewPostViewController(viewModel: viewModel)
            self.present(vc, animated: true)
        }), for: .touchUpInside)
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("uploadedImageFetchUser"), object: nil, queue: nil) { _ in
            self.viewModel.fetchAllPosts()
        }
    }
    
    // MARK: - Network Manager calls
    
    private func fetchCurrentUser() {
        self.viewModel.fetchCurrentUser()
    }
    
    private func fetchPosts() {
        viewModel.fetchAllPosts()
    }
    
    // MARK: - Functions
    
    //show side menu
    @objc func didTapProfileImage() {
        addPostButton.isHidden = true
        navigationController?.navigationBar.isHidden = true
        view.addSubview(unfocusView)
        unfocusView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        view.addSubview(sideMenu)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.sideMenu.transform = CGAffineTransform(rotationAngle: 0.01)
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
                self.sideMenu.transform = self.sideMenu.transform.translatedBy(x: 250, y: 0)
            } completion: { _ in
                self.sideMenu.sideMenuDidApear()
            }
        }
    }
    
    //hide side menu
    @objc func didTapLeave() {
        navigationController?.navigationBar.isHidden = false
        unfocusView.removeFromSuperview()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.sideMenu.transform = CGAffineTransform(translationX: -250, y: 0)
        } completion: { _ in
            UIView.animate(withDuration: 0.8, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
                self.sideMenu.transform = self.sideMenu.transform.rotated(by: -0.01)
            } completion: { _ in
                
            }
        }
        self.sideMenu.sideMenuDisapear()
        addPostButton.isHidden = false
    }
    
    private func checkIfThereArePosts() {
        DispatchQueue.main.async { [self] in
            if posts.isEmpty {
                feedTableView.isHidden = true
                noPostsLabel.isHidden = false
            } else {
                noPostsLabel.isHidden = true
                feedTableView.isHidden = false
                feedTableView.reloadData()
            }
        }
    }

}
// MARK: - Extensions : TableView
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier) as? FeedTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.delegate = self
        if !posts.isEmpty {
            let currentPost = posts[indexPath.row]
            cell.post = currentPost
            cell.configure()
        }
        let currentPost = posts[indexPath.row]
        cell.post = currentPost
        cell.configure()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
}

// MARK: - Extensions : SideMenu
extension FeedViewController: SideMenuViewDelegate {
    //Show profile
    func SideMenuViewDidTapProfileButton() {
        print("DEBUG: Show Profile")
        didTapLeave()
        viewModel.fetchCurrentUserProfile()
    }
    
    //Show Setting
    func SideMenuViewDidTapSettingButton() {
        let vc = SettingsViewController()
        didTapLeave()
        vc.title = "Settings"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //Log out
    func SideMenuViewDidTapLogOut() {
        AlertManager.shared.showConfirmOrDeclineAlert(viewController: self, title: "LogOut", message: "Are you sure to Logout ?") {[weak self] confirm in
            if confirm {
                self?.viewModel.logOut()
            } else {
                self?.didTapLeave()
            }
        }
    }

}

// MARK: - Extensions : TableView Cell
extension FeedViewController: FeedTableViewCellDelegate {
    
    //show user profile
    func FeedTableViewCellShowProfile(user: User) {
        let userService : ProfileUserService = UserManager()
        let imageUploader: ImageUploader = StorageManager()
        let postService: ProfilePostsService = PostsManager(imageUploaderService: imageUploader)
        let viewModel = ProfileViewModel(user: user, userService: userService, postsService: postService)
        let vc = ProfileViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //like post
    func FeedTableViewCellDidTapLike(post: Post) {
        viewModel.likedUnlikedPost(post: post)
    }
    
    //comment post
    
    func FeedTableViewCellDidTapComment(post: Post) {
        let commentService: CommentService = CommentsManager()
        let vm = CommentsViewModel(post: post, commentService: commentService)
        let vc = CommentsViewController(viewModel: vm)
        vc.modalPresentationStyle = .pageSheet
        navigationController?.present(vc, animated: true)
    }
    
    //share post
    func FeedTableViewCellDidTapShare() {
        print("DEBUG: TAP SHARE")
    }
    
    //show more information
    func FeedTableViewCellDidTapSeeMore() {
        print("DEBUG: TAP MORE")
    }

}

// MARK: - Extensions : View Model Delegate
extension FeedViewController: FeedViewModelOutPut {
    
    func likedPost(post: Post) {
        if let replacePostIndex = posts.firstIndex(where: {$0.id == post.id}) {
            posts[replacePostIndex] = post
        }
        DispatchQueue.main.async {
            self.feedTableView.reloadData()
        }
    }
    
    // fetch all feed posts / TODO: Fetch only following posts
    func didFetchPosts(posts: [Post]) {
        self.posts = posts
        self.checkIfThereArePosts()
        DispatchQueue.main.async {
            self.feedTableView.reloadData()
        }
    }
    
    // error handling
    func showErrorFetchingPosts(ErrorLocalizedDescription: String) {
        AlertManager().showErrorAlert(viewcontroller: self, error: ErrorLocalizedDescription)
    }
    
    //log out
    func returnToLoginScreen() {
        let loginService : LoginService = AuthManager()
        let viewModel = LoginViewModel(loginService: loginService)
        let vc = SignInViewController(viewModel: viewModel)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    //side menu informations
    func setUserInformations(profileImage: UIImage, username: String, nickname: String) {
        NavBarProfileImage = profileImage
        sideMenu.configure(profileImage: profileImage, username: username, nickname: nickname)
        setupProfileImage()
        setupNavBar()
    }
    
    //error handling: Getting current user
    func showErrorFetchingCurrentUser(errorLocalizedDescription: String) {
        print(errorLocalizedDescription)
    }
    
    //show current user profile : Side mennu
    func getCurrentUserProfile(user: User) {
        let userService: ProfileUserService = UserManager()
        let imageUploader: ImageUploader = StorageManager()
        let postsService: ProfilePostsService = PostsManager(imageUploaderService: imageUploader)
        let viewModel = ProfileViewModel(user: user, userService: userService,postsService: postsService)
        let vc = ProfileViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
