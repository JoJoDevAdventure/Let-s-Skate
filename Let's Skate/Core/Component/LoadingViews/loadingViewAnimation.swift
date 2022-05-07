//
//  loadingViewAnimation.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 07/05/2022.
//

import Foundation
import Lottie
import UIKit

class LoadingAnimationView {
    func animateLoadingScreen(view: UIView, animation: AnimationView, isUploading: Bool) {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 0.7
        let upView = UIView()
        if isUploading == true {
            //upview
            upView.translatesAutoresizingMaskIntoConstraints = false
            upView.backgroundColor = .clear
            view.addSubview(upView)
            NSLayoutConstraint.activate([
              upView.topAnchor.constraint(equalTo: view.topAnchor),
              upView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              upView.heightAnchor.constraint(equalTo: view.heightAnchor),
              upView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
            //blur
            blurView.translatesAutoresizingMaskIntoConstraints = false
            upView.insertSubview(blurView, at: 0)
            NSLayoutConstraint.activate([
              blurView.topAnchor.constraint(equalTo: upView.topAnchor),
              blurView.leadingAnchor.constraint(equalTo: upView.leadingAnchor),
              blurView.heightAnchor.constraint(equalTo: upView.heightAnchor),
              blurView.widthAnchor.constraint(equalTo: upView.widthAnchor)
            ])
            //animation
            view.addSubview(animation)
            animation.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            animation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            animation.play()
        } else {
            upView.removeFromSuperview()
            animation.removeFromSuperview()
        }
    }
}
