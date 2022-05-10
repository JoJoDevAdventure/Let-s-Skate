//
//  AlertManager.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 22/04/2022.
//

import Foundation
import UIKit

enum pickingMod {
    case library
    case camera
}

class AlertManager {
    
    static let shared = AlertManager()
    
    //alert with confirm or decline
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
    
    //show error with custom message
    func showErrorAlert(viewcontroller: UIViewController, error: String) {
        let alert = UIAlertController(title: "", message: "\(error)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        viewcontroller.present(alert, animated: true, completion: nil)
    }
    
    func picPictureAlert(_ viewController : UIViewController,_ of: String, completion : (@escaping(pickingMod)->Void)) {
        //check if camera isEnabled
        let hasCam = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //alert setup
        let alert = UIAlertController(title: "Select a photo", message: "\(of)", preferredStyle: .actionSheet)
        let selectFromLibrary = UIAlertAction(title: "Select from Library", style: .default) { action in
            //show a picker from library
            completion(.library)
        }
        alert.addAction(selectFromLibrary)
        let pickFromCamera = UIAlertAction(title: "Pick from CameraRoll", style: .default) { action in
            //show cameraRoll picker
            completion(.camera)
        }
        if hasCam {
            alert.addAction(pickFromCamera)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        viewController.present(alert, animated: true)
    }
    
}
