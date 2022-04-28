//
//  WelcomeViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 25/04/2022.
//

import UIKit
import Lottie

enum WelcomeScreenState {
    case first
    case second
    case final
}

class WelcomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var username : String = ""
    private var state: WelcomeScreenState = .first
    
    private let welcomeMainLabel: MainWelcomeLabel = {
        let label = MainWelcomeLabel()
        label.text = "Welcome XXXXXXXXXXXXXXXXXXXXXXX!"
        label.numberOfLines = 2
        label.alpha = 0
        return label
    }()
    
    private let welcomeSecondLabel: DescWelcomeLabel = {
        let label = DescWelcomeLabel()
        label.text = "You just joined us and you seem to have a great sense of adventure.\nYou're in the right place here!"
        label.numberOfLines = 0
        label.alpha = 0
        return label
    }()
    
    private let firstAnimation: AnimationView = {
        let animation = AnimationView()
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.animation = Animation.named("welcomeViewSkater")
        animation.loopMode = .loop
        animation.contentMode = .scaleAspectFill
        animation.alpha = 0
        return animation
    }()
    
    private let secondAnimation: AnimationView = {
        let animation = AnimationView()
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.animation = Animation.named("secondWelcomeViewSkater")
        animation.loopMode = .loop
        animation.contentMode = .scaleAspectFill
        animation.alpha = 0
        return animation
    }()
    
    private let finalAnimation: AnimationView = {
        let animation = AnimationView()
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.animation = Animation.named("finalWelcomeView")
        animation.loopMode = .loop
        animation.contentMode = .scaleAspectFill
        animation.alpha = 0
        return animation
    }()
    
    private let continueButton: AuthButton = {
        let button = AuthButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.layer.borderWidth = 2
        button.alpha = 0
        return button
    }()
    
    private let viewModel: WelcomeViewModel
    
    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.output = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().DarkMainColor()
        setupGestureReconizer()
        setupLabelsText()
        setupContinueButton()
        WelcomeInAnimation(mainLabel: welcomeMainLabel, secondLabel: welcomeSecondLabel, animation: firstAnimation)
    }
    
    // MARK: - Set up
    
    private func setupGestureReconizer() {
        let toRightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeToRight))
        toRightSwipe.direction = .left
        view.addGestureRecognizer(toRightSwipe)
        let tap = UITapGestureRecognizer(target: self, action: #selector(swipeToRight))
        view.addGestureRecognizer(tap)
    }
    
    private func setupContinueButton() {
        continueButton.addAction(UIAction(handler: { _ in
            let vc = EmailVerificationViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }), for: .touchUpInside)
    }
    
    // MARK: - Functions
    
    @objc func swipeToRight() {
        view.isUserInteractionEnabled = false
        switch state {
        case .first:
            WelcomeOutAnimation(mainLabel: welcomeMainLabel, secondLabel: welcomeSecondLabel, animation: firstAnimation) {[weak self] _ in
                guard let strongSelf = self else { return }
                self?.state = .second
                self?.setupLabelsText()
                self?.WelcomeInAnimation(mainLabel: strongSelf.welcomeMainLabel, secondLabel: strongSelf.welcomeSecondLabel, animation: strongSelf.secondAnimation)
                self?.view.isUserInteractionEnabled = true
            }
        case .second:
            WelcomeOutAnimation(mainLabel: welcomeMainLabel, secondLabel: welcomeSecondLabel, animation: secondAnimation) {[weak self] _ in
                guard let strongSelf = self else { return }
                self?.state = .final
                self?.setupLabelsText()
                self?.WelcomeInAnimation(mainLabel: strongSelf.welcomeMainLabel, secondLabel: strongSelf.welcomeSecondLabel, animation: strongSelf.finalAnimation)
                self?.view.isUserInteractionEnabled = true
            }
        case .final:
            return
        }
    }

    func setupLabelsText() {
        switch state {
        case .first:
            welcomeMainLabel.text = "Welcome \(username)"
            welcomeSecondLabel.text = "You just joined us and you seem to have a great sense of adventure.\nYou're in the right place here!"
        case .second:
            welcomeMainLabel.text = "Discover, Share, Enjoy."
            welcomeSecondLabel.text = "Here we are a family, we care about each other, we believe in peace.\nWe share the same passion."
        case .final:
            welcomeMainLabel.text = "One more step!"
            welcomeSecondLabel.text = "Click on 'continue' to confirm email & finish your profile with more informations."
        }
    }
    
    private func WelcomeInAnimation(mainLabel: MainWelcomeLabel, secondLabel: DescWelcomeLabel, animation: AnimationView) {
        view.addSubview(mainLabel)
        let mainConstraints = [
            welcomeMainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -220),
            welcomeMainLabel.widthAnchor.constraint(equalToConstant: 350),
            welcomeMainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(mainConstraints)
        
        view.addSubview(secondLabel)
        let descConstraints = [
            welcomeSecondLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeSecondLabel.topAnchor.constraint(equalTo: welcomeMainLabel.bottomAnchor, constant: 20),
            welcomeSecondLabel.widthAnchor.constraint(equalToConstant: 350)
        ]
        NSLayoutConstraint.activate(descConstraints)
        
        view.addSubview(animation)
        if animation == firstAnimation {
            let animationConstraints = [
                animation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                animation.topAnchor.constraint(equalTo: welcomeSecondLabel.bottomAnchor),
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
            UIView.animate(withDuration: 0.6, delay: 1.4, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {[weak self] in
                self?.continueButton.alpha = 1
            }
        }
    }
    
    private func WelcomeOutAnimation(mainLabel: MainWelcomeLabel, secondLabel: DescWelcomeLabel, animation: AnimationView, completion: @escaping (Bool?)->Void) {
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
        
        UIView.animate(withDuration: 1, delay: 0.6, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {[weak self] in
            if animation == self?.secondAnimation {
                animation.transform = CGAffineTransform(translationX: 0, y: 30)
            } else {
                animation.transform = CGAffineTransform(translationX: -20, y: 0)
            }
            
        } completion: { _ in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
                if animation == self.secondAnimation {
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
                if animation == self.secondAnimation {
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

// MARK: - Extensions
extension WelcomeViewController: WelcomeViewModelOutPut {
    
}
