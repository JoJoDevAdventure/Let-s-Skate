//
//  LightLoadingAnimation.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 01/06/2022.
//

import UIKit
import Lottie

class LightLoadingAnimation: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        NSLayoutConstraint.pinToView(self, loadingAnimation, padding: 5)
        translatesAutoresizingMaskIntoConstraints = false
        play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let loadingAnimation: AnimationView = {
        let animation = AnimationView()
        animation.animation = Animation.named("lightLoadingView")
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.heightAnchor.constraint(equalToConstant: 150).isActive = true
        animation.widthAnchor.constraint(equalToConstant: 150).isActive = true
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        return animation
    }()
    
    private func play() {
        loadingAnimation.play()
    }
    
    public func pause() {
        loadingAnimation.pause()
    }
    
    public func show(view: UIView) {
        view.addSubview(self)
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    public func dismiss() {
        self.removeFromSuperview()
    }
    
    
}
