//
//  SettingViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 21/04/2022.
//

import Foundation

enum SettingViewModel: CaseIterable {
    case inviteFriends
    case notifications
    case confidentiality
    case security
    case account
    case help
    case info
    
    var title: String {
        switch self {
        case .inviteFriends: return "Invite friends & Find contacts"
        case .notifications: return "Notifications"
        case .confidentiality: return "Confidentiality"
        case .security: return "Security"
        case .account: return "Account"
        case .help: return "Help"
        case .info: return "Info"
        }
    }
    
    var iconName: String {
        switch self {
        case .inviteFriends: return "person.badge.plus"
        case .notifications: return "bell"
        case .confidentiality: return "lock.shield"
        case .security: return "lock"
        case .account: return "person"
        case .help: return "questionmark"
        case .info: return "info.circle"
        }
    }
    
    var row: Int {
        switch self {
        case .inviteFriends:
            return 0
        case .notifications:
            return 1
        case .confidentiality:
            return 2
        case .security:
            return 3
        case .account:
            return 4
        case .help:
            return 5
        case .info:
            return 6
        }
    }
    
}
