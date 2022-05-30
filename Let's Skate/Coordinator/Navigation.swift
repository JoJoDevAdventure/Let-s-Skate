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
    let logOutService: LogOutService = AuthManager()
    let imageUploaderService: ImageUploader = StorageManager()
    
    
    // Core Tabs
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
        let viewModel = MessagingViewModel()
        return MessagesViewController()
    }
}
