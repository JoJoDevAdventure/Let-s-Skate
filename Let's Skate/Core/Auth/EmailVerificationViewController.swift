//
//  EmailVerificationViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 26/04/2022.
//

import UIKit
import Lottie

class EmailVerificationViewController: UIViewController {
    
    
    // MARK: - Properties
    
    var userEmail: String = ""
    
    private let sentAnimation: AnimationView = {
        let view = AnimationView()
        view.animation = Animation.named("emailVerificationAnimation")
        view.loopMode = .loop
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.play()
        return view
    }()
    
    private let sendingEmailAnimation: AnimationView = {
        let view = AnimationView()
        view.animation = Animation.named("sendingEmailAnimation")
        view.loopMode = .playOnce
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()
    
    private let confirmMailLabel: MainWelcomeLabel = {
        let label = MainWelcomeLabel()
        label.text = "Email Verification Sent."
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    private let confirmMailDescLabel: DescWelcomeLabel = {
        let label = DescWelcomeLabel()
        label.font = .systemFont(ofSize: 22)
        label.numberOfLines = 0
        return label
    }()
    
    private let confirmMailButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done !", for: .normal)
        button.setTitleColor(UIColor().DarkMainColor(), for: .normal)
        button.backgroundColor = UIColor().lightMainColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor().DarkMainColor().cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        return button
    }()
    
    private let resendMailLabel: DescWelcomeLabel = {
        let label = DescWelcomeLabel()
        label.text = "didn't recive email ? \nClick 'Resend' to retry."
        label.font = .systemFont(ofSize: 22)
        label.numberOfLines = 0
        return label
    }()
    
    private let resendMailButton: UIButton = {
        let button = UIButton()
        button.setTitle("Resend", for: .normal)
        button.backgroundColor = UIColor().DarkMainColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        return button
    }()
    
    private let resendCountLabel: UILabel = {
        let label = UILabel()
        label.text = "(30)"
        label.textColor = UIColor().lightMainColor()
        label.font = .systemFont(ofSize: 22, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let viewModel: EmailVerificationViewModel
    
    init(viewModel: EmailVerificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.output = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().DarkMainColor()
        setupSubViews()
        setupConstraints()
        setupButtonsActions()
    }
    
    // MARK: - Set up

    private func setupSubViews() {
        view.addSubview(confirmMailLabel)
        confirmMailDescLabel.text = "We sent you a verification email to '\(userEmail)', check your mail box to confirm."
        view.addSubview(confirmMailDescLabel)
        view.addSubview(confirmMailButton)
        view.addSubview(sentAnimation)
        view.addSubview(resendMailLabel)
        view.addSubview(resendMailButton)
        view.addSubview(resendCountLabel)
        view.addSubview(sendingEmailAnimation)
    }
    
    override func viewDidLayoutSubviews() {
        sendingEmailAnimation.frame = view.bounds
    }
    
    private func setupConstraints() {
        
        let sentAnimationConstraints = [
            sentAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sentAnimation.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            sentAnimation.widthAnchor.constraint(equalToConstant: 100),
            sentAnimation.heightAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(sentAnimationConstraints)
        
        let mainLabelConstraits = [
            confirmMailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmMailLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -250),
        ]
        NSLayoutConstraint.activate(mainLabelConstraits)
        
        let descLabelConstraints = [
            confirmMailDescLabel.leftAnchor.constraint(equalTo: confirmMailLabel.leftAnchor, constant: 5),
            confirmMailDescLabel.topAnchor.constraint(equalTo: confirmMailLabel.bottomAnchor, constant: 20),
            confirmMailDescLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100)
        ]
        NSLayoutConstraint.activate(descLabelConstraints)
        
        let confirmButtonConstraints = [
            confirmMailButton.topAnchor.constraint(equalTo: confirmMailDescLabel.bottomAnchor, constant: 20),
            confirmMailButton.centerXAnchor.constraint(equalTo: confirmMailDescLabel.centerXAnchor, constant: -10),
            confirmMailButton.heightAnchor.constraint(equalToConstant: 40),
            confirmMailButton.widthAnchor.constraint(equalToConstant: 100),
        ]
        NSLayoutConstraint.activate(confirmButtonConstraints)
        
        let resendEmailLabelConstraints = [
            resendMailLabel.leftAnchor.constraint(equalTo: confirmMailLabel.leftAnchor, constant: 5),
            resendMailLabel.topAnchor.constraint(equalTo: confirmMailButton.bottomAnchor, constant: 50),
            resendMailLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100)
        ]
        NSLayoutConstraint.activate(resendEmailLabelConstraints)
        
        let resendButtonConstraints = [
            resendMailButton.topAnchor.constraint(equalTo: resendMailLabel.bottomAnchor, constant: 20),
            resendMailButton.centerXAnchor.constraint(equalTo: resendMailLabel.centerXAnchor, constant: -10),
            resendMailButton.heightAnchor.constraint(equalToConstant: 40),
            resendMailButton.widthAnchor.constraint(equalToConstant: 100),
        ]
        NSLayoutConstraint.activate(resendButtonConstraints)
        
        let resendCountLabelConstraints = [
            resendCountLabel.leftAnchor.constraint(equalTo: resendMailButton.rightAnchor, constant: 10),
            resendCountLabel.centerYAnchor.constraint(equalTo: resendMailButton.centerYAnchor)
        ]
        NSLayoutConstraint.activate(resendCountLabelConstraints)
    }
    
    private func setupButtonsActions() {
        resendMailButton.addAction(UIAction(handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            self?.viewModel.resendVerificationEmail(viewController: strongSelf)
        }), for: .touchUpInside)
        
        confirmMailButton.addAction(UIAction(handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            self?.viewModel.checkEmailVerification(viewController: strongSelf)
        }), for: .touchUpInside)
    }
    
    // MARK: - Functions
    
    private func sendVerificationEmailAnimation() {
        var remainingTime = 30
        resendCountLabel.isHidden = false
        sendingEmailAnimation.isHidden = false
        sendingEmailAnimation.play(completion: {[weak self] _ in
            self?.sendingEmailAnimation.isHidden = true
        })
        resendMailButton.backgroundColor = .gray
        resendMailButton.isEnabled = false
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {[weak self] timer in
            remainingTime -= 1
            self?.resendCountLabel.text = "(\(remainingTime))"
            if remainingTime == 0 {
                self?.resendMailButton.isEnabled = true
                self?.resendMailButton.backgroundColor = UIColor().DarkMainColor()
                self?.resendCountLabel.isHidden = true
                timer.invalidate()
            }
        }
        
    }
    
}
// MARK: - Extensions
extension EmailVerificationViewController : EmailVerificationViewModelOutPut  {
    func emailVerificationDone() {
        let vc = mainNavigationBar()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    func emailVerificationResent() {
        sendVerificationEmailAnimation()
    }
}
