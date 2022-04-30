//
//  WelcomeAnimations.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 29/04/2022.
//

import Foundation
import UIKit
import Lottie



class WelcomeAnimations {
    
    func WelcomeInAnimation(view: UIView, mainLabel: MainWelcomeLabel, secondLabel: DescWelcomeLabel, animation: AnimationView, firstAnimation: AnimationView?, secondAnimation: AnimationView?, continueButton: UIButton, state: WelcomeScreenState ) {
        view.addSubview(mainLabel)
        let mainConstraints = [
            mainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -220),
            mainLabel.widthAnchor.constraint(equalToConstant: 350),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(mainConstraints)
        
        view.addSubview(secondLabel)
        let descConstraints = [
            secondLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20),
            secondLabel.widthAnchor.constraint(equalToConstant: 350)
        ]
        NSLayoutConstraint.activate(descConstraints)
        
        view.addSubview(animation)
        if animation == firstAnimation {
            let animationConstraints = [
                animation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                animation.topAnchor.constraint(equalTo: secondLabel.bottomAnchor),
                animation.widthAnchor.constraint(equalToConstant: 220),
                animation.heightAnchor.constraint(equalToConstant: 400)
            ]
            NSLayoutConstraint.activate(animationConstraints)
        } else if animation == secondAnimation {
            let animationConstraints = [
                animation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                animation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 15),
                animation.widthAnchor.constraint(equalTo: view.widthAnchor),
                animation.heightAnchor.constraint(equalToConstant: 300)
            ]
            NSLayoutConstraint.activate(animationConstraints)
        } else {
            view.addSubview(continueButton)
            let animationConstraints = [
                animation.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
                animation.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                animation.widthAnchor.constraint(equalToConstant: 300),
                animation.heightAnchor.constraint(equalToConstant: 300)
            ]
            NSLayoutConstraint.activate(animationConstraints)
            
            let buttonConstraints = [
                continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                continueButton.topAnchor.constraint(equalTo: secondLabel.bottomAnchor, constant: 100)
            ]
            NSLayoutConstraint.activate(buttonConstraints)
        }
        animation.play()
        
        UIView.animate(withDuration: 0.8, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            mainLabel.alpha = 1
        }
        UIView.animate(withDuration: 0.8, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            secondLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.7, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            animation.alpha = 1
        }
        
        if state == .final {
            UIView.animate(withDuration: 0.6, delay: 1.4, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
                continueButton.alpha = 1
            }
        }
    }
    
    func WelcomeOutAnimation(mainLabel: MainWelcomeLabel, secondLabel: DescWelcomeLabel, animation: AnimationView, firstAnimation: AnimationView?, secondAnimation: AnimationView?, completion: @escaping (Bool?)->Void) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            mainLabel.transform = CGAffineTransform(translationX: -20, y: 0)
        } completion: { _ in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
                mainLabel.transform = mainLabel.transform.translatedBy(x: 0, y: -200)
                mainLabel.alpha = 0
            }
        }
        UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            secondLabel.transform = CGAffineTransform(translationX: -20, y: 0)
        } completion: { _ in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
                secondLabel.transform = secondLabel.transform.translatedBy(x: 0, y: -200)
                secondLabel.alpha = 0
            }
        }
        
        UIView.animate(withDuration: 1, delay: 0.6, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            if animation == secondAnimation {
                animation.transform = CGAffineTransform(translationX: 0, y: 30)
            } else {
                animation.transform = CGAffineTransform(translationX: -20, y: 0)
            }
            
        } completion: { _ in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
                if animation == secondAnimation {
                    animation.transform = animation.transform.scaledBy(x: 1.4, y: 1.4)
                } else {
                    animation.transform = animation.transform.translatedBy(x: 0, y: -200)
                }
                animation.alpha = 0
            } completion: { _ in
                mainLabel.transform = mainLabel.transform.translatedBy(x: 0, y: 200)
                mainLabel.transform = mainLabel.transform.translatedBy(x: 20, y: 0)
                secondLabel.transform = secondLabel.transform.translatedBy(x: 0, y: 200)
                secondLabel.transform = secondLabel.transform.translatedBy(x: 20, y: 0)
                if animation == secondAnimation {
                    animation.transform = animation.transform.translatedBy(x: 0, y: -30)
                    animation.transform = animation.transform.scaledBy(x: -1.4, y: -1.4)
                } else {
                    animation.transform = animation.transform.translatedBy(x: 0, y: 200)
                    animation.transform = animation.transform.translatedBy(x: 20, y: 0)
                }
                mainLabel.removeFromSuperview()
                secondLabel.removeFromSuperview()
                animation.removeFromSuperview()
                completion(true)
            }
        }
    }
    
}
