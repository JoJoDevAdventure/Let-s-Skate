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
        switch self {
        case .feedView :
            return Navigation.shared.getFeedViewController()
        case .exploreView :
            return Navigation.shared.getExploreViewController()
        case .seachView :
            return Navigation.shared.getSearchViewController()
        case .messagesView :
            return Navigation.shared.getMessagesViewController()
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
