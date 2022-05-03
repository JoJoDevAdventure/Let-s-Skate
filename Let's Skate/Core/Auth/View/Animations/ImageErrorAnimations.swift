//
//  ImageErrorAnimations.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 03/05/2022.
//

import Foundation
import UIKit

class ImageErrorAnimations {
    
    public func animateImage(imageView: UIImageView) {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            imageView.backgroundColor = .red
            imageView.backgroundColor = .gray
        }
    }
    
}
