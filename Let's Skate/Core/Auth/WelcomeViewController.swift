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
    let animations = WelcomeAnimations()
    
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
        animations.WelcomeInAnimation(view: view, mainLabel: welcomeMainLabel, secondLabel: welcomeSecondLabel, animation: firstAnimation, firstAnimation: firstAnimation, secondAnimation: nil, continueButton: continueButton, state: state)
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
        continueButton.addAction(UIAction(handler: {[weak self] _ in
            self?.viewModel.verifyUserEmail()
        }), for: .touchUpInside)
    }
    
    // MARK: - Functions
    
    @objc func swipeToRight() {
        view.isUserInteractionEnabled = false
        switch state {
        case .first:
            animations.WelcomeOutAnimation(mainLabel: welcomeMainLabel, secondLabel: welcomeSecondLabel, animation: firstAnimation, firstAnimation: firstAnimation, secondAnimation: nil) {[weak self] _ in
                guard let strongSelf = self else { return }
                self?.state = .second
                self?.setupLabelsText()
                self?.animations.WelcomeInAnimation(view: strongSelf.view, mainLabel: strongSelf.welcomeMainLabel, secondLabel: strongSelf.welcomeSecondLabel, animation: strongSelf.secondAnimation, firstAnimation: nil, secondAnimation: strongSelf.secondAnimation, continueButton: strongSelf.continueButton, state: strongSelf.state)
                self?.view.isUserInteractionEnabled = true
            }
        case .second:
            animations.WelcomeOutAnimation(mainLabel: welcomeMainLabel, secondLabel: welcomeSecondLabel, animation: secondAnimation, firstAnimation: nil, secondAnimation: secondAnimation) {[weak self] _ in
                guard let strongSelf = self else { return }
                self?.state = .final
                self?.setupLabelsText()
                self?.animations.WelcomeInAnimation(view: strongSelf.view, mainLabel: strongSelf.welcomeMainLabel, secondLabel: strongSelf.welcomeSecondLabel, animation: strongSelf.finalAnimation, firstAnimation: nil, secondAnimation: nil, continueButton: strongSelf.continueButton, state: strongSelf.state)
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
    
    
}

// MARK: - Extensions
extension WelcomeViewController: WelcomeViewModelOutPut {
    func verificationEmailSent(email: String) {
        let service : UserEmailVerificationService = AuthManager()
        let viewModel = EmailVerificationViewModel(verificationEmailService: service)
        let vc = EmailVerificationViewController(viewModel: viewModel)
        vc.userEmail = email
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
