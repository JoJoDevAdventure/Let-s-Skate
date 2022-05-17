//
//  TabBarModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 16/04/2022.
//

import Foundation
import UIKit

enum TabBarModel: CaseIterable {
    case feedView
    case exploreView
    case seachView
    case messagesView

    var viewController: UIViewController {
        let imageUploaderService: ImageUploader = StorageManager()
        switch self {
        case .feedView :
            let service: LogOutService = AuthManager()
            let userService: FeedUserService = UserManager()
            let feedPostsService: FeedPostsService = PostsManager(imageUploaderService: imageUploaderService)
            let viewModel = FeedViewModel(logoutService: service, userService: userService , postsService: feedPostsService)
            return FeedViewController(viewModel: viewModel)
            
        case .exploreView :
            let explorePostsService: ExplorePostService = PostsManager(imageUploaderService: imageUploaderService)
            let viewModel = ExploreViewModel(postService: explorePostsService)
            return ExploreViewController(viewModel: viewModel)
            
        case .seachView :
            return SearchViewController()
            
        case .messagesView :
            return MessagesViewController()
        }
    }
    
    var title: String {
        switch self {
        case .feedView: return "Skaters Place"
        case .exploreView: return "Explore"
        case .seachView: return "Find friends"
        case .messagesView: return " Chats"
        }
    }
    
    var iconName: String {
        switch self {
        case .feedView: return "circle.circle"
        case .exploreView: return "globe"
        case .seachView: return "magnifyingglass.circle"
        case .messagesView:  return "bubble.right.circle"
        }
    }
    
}
