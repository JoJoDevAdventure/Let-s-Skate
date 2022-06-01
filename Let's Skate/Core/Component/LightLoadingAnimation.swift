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
        addSubview(loadingAnimation)
        NSLayoutConstraint.pinToView(self, loadingAnimation, padding: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let loadingAnimation: AnimationView = {
        let animation = AnimationView()
        animation.animation = Animation.named("lightLoadingView")
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.heightAnchor.constraint(equalToConstant: 160).isActive = true
        animation.widthAnchor.constraint(equalToConstant: 160).isActive = true
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        return animation
    }()
    
    public func play() {
        loadingAnimation.play()
    }
    
    public func pause() {
        loadingAnimation.pause()
    }
    
    
}
