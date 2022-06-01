//
//  Navigation.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 30/05/2022.
//

import Foundation
import UIKit

final class Navigation: Coordinator {
    
    static let shared = Navigation()
    
    // Managers :
    
    
    /// Services :
    let imageUploaderService: ImageUploader = StorageManager()
    
    // MARK: - Get Core ViewControllers
    public func getFeedViewController() -> UIViewController {
        let logOutService: LogOutService = AuthManager()
        let feedUserService: FeedUserService = UserManager()
        let feedPostsService: FeedPostsService = PostsManager(imageUploaderService: imageUploaderService)
        let viewModel = FeedViewModel(logoutService: logOutService, userService: feedUserService, postsService: feedPostsService)
        return FeedViewController(viewModel: viewModel)
    }
    
    public func getExploreViewController() -> UIViewController {
        let explorePostsService: ExplorePostService = PostsManager(imageUploaderService: imageUploaderService)
        let viewModel = ExploreViewModel(postService: explorePostsService)
        return ExploreViewController(viewModel: viewModel)
    }
    
    public func getSearchViewController() -> UIViewController {
        let seachService: SearchUserService = UserManager()
        let viewModel = SearchViewModel(searchUserService: seachService)
        return SearchViewController(viewModel: viewModel)
    }
    
    public func getMessagesViewController() -> UIViewController {
        let messagingService: MessagingService = MessagingManager()
        let viewModel = MessagingViewModel(messageService: messagingService)
        return MessagesViewController(viewModel: viewModel)
    }
    
    
    // MARK: - Navigation
    
    public func goToProfileViewController(from viewController: UIViewController, with user: User) {
        let profilePostsService: ProfilePostsService = PostsManager(imageUploaderService: imageUploaderService)
        let profileUserService: ProfileUserService = UserManager()
        let viewModel = ProfileViewModel(user: user, userService: profileUserService, postsService: profilePostsService)
        let profileVC = ProfileViewController(viewModel: viewModel)
        viewController.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    public func goToSettingsViewController(from viewController: UIViewController) {
        let settingsViewController = SettingsViewController()
        settingsViewController.title = "Settings"
        viewController.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    public func goToFollowersFollowing(from viewController: UIViewController, followersFollowing: String, user: User) {
        let vc = ListViewController()
        vc.title = followersFollowing
        guard let followers = user.followers else { return }
        vc.users = followers
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    public func goToChatViewController(from viewController: UIViewController) {
        let vc = ChatViewController()
        vc.title = "Jenny Smith"
        vc.navigationItem.largeTitleDisplayMode = .never
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Present
    
    public func showCommentsViewController(from viewController: UIViewController, post: Post) {
        let commentService: CommentService = CommentsManager()
        let vm = CommentsViewModel(post: post, commentService: commentService)
        let vc = CommentsViewController(viewModel: vm)
        vc.modalPresentationStyle = .pageSheet
        viewController.navigationController?.present(vc, animated: true)
    }
    
    public func showNewPostViewController(from viewController: UIViewController) {
        let imageUploadService: ImageUploader = StorageManager()
        let service: NewPostService = PostsManager(imageUploaderService: imageUploadService)
        let viewModel = NewPostViewModel(postsService: service)
        let vc = AddNewPostViewController(viewModel: viewModel)
        viewController.present(vc, animated: true)
    }
    
}
