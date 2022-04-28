//
//  AlertManager.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 22/04/2022.
//

import Foundation
import UIKit

class AlertManager {
    
    static let shared = AlertManager()
    
    func showConfirmOrDeclineAlert(viewController : UIViewController, title: String, message: String, completion: @escaping (Bool)->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let decline = UIAlertAction(title: "Decline", style: .cancel) { _ in
            completion(false)
        }
        let confirm = UIAlertAction(title: "Confirm", style: .destructive) { _ in
            completion(true)
        }
        alert.addAction(decline)
        alert.addAction(confirm)
        viewController.present(alert, animated: true)
    }
    
    func showErrorAlert(viewcontroller: UIViewController, error: String) {
        let alert = UIAlertController(title: "", message: "\(error)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        viewcontroller.present(alert, animated: true, completion: nil)
    }
    
}
