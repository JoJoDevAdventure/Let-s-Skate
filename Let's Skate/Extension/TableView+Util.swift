//
//  TableView+.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 28/05/2022.
//

import Foundation
import UIKit

extension UITableView {
    
    public func reuseIdentifier<T>(for type: T.Type) -> String {
        return String(describing: type)
    }
    
    public func dequeResuableCell<T: UITableViewCell>(for type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier(for: type), for: indexPath) as? T else {
            fatalError("failed to deque cell.")
        }
        return cell
    }
    
    public func registerCell<T: UITableViewCell>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: reuseIdentifier(for: type))
    }
    
}
