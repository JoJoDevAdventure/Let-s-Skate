//
//  SignUpViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 22/04/2022.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    private let headerView: AuthHeaderView = {
        let view = AuthHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 320).isActive = true
        view.setup(first: "New member?", second: "Join us right now !")
        return view
    }()
    
    private let backgroundPhoto: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "SignUpBackground")
        return image
    }()
    
    private let emailTextField: AuthTextfield = {
        let textfield = AuthTextfield()
        textfield.placeholder = "E-mail"
        return textfield
    }()
    
    private let usernameTextField: AuthTextfield = {
        let textfield = AuthTextfield()
        textfield.placeholder = "Username"
        return textfield
    }()
    
    private let passwwordTextField: AuthTextfield = {
        let textfield = AuthTextfield()
        textfield.placeholder = "Password"
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    private let signupButton: AuthButton = {
        let button = AuthButton()
        button.setTitle("Sign Up", for: .normal)
        return button
    }()
    
    private let usernameErrorLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let emailErrorLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let passwordErrorLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let viewModel: RegistrationViewModel
    
    init(viewModel: RegistrationViewModel) {
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
        setupSubView()
        setupConstraints()
        setupButtonAction()
    }
    
    // MARK: - Set up
    
    private func setupSubView() {
        view.addSubview(backgroundPhoto)
        view.addSubview(headerView)
        view.addSubview(usernameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwwordTextField)
        view.addSubview(signupButton)
        view.addSubview(usernameErrorLabel)
        view.addSubview(emailErrorLabel)
        view.addSubview(passwordErrorLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundPhoto.frame = view.bounds
    }
    
    private func setupConstraints() {
        let headerViewConstraints = [
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: -100),
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 100),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant:  -100),
        ]
        NSLayoutConstraint.activate(headerViewConstraints)
        
        let usernameTFConstraints = [
            usernameTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 70),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(usernameTFConstraints)
        
        let usernameErrorConstraints = [
            usernameErrorLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10),
            usernameErrorLabel.leftAnchor.constraint(equalTo: usernameTextField.leftAnchor),
            usernameErrorLabel.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor)
        ]
        NSLayoutConstraint.activate(usernameErrorConstraints)
        
        let emailTFConstraints = [
            emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 50),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(emailTFConstraints)
        
        let emailErrorConstraints = [
            emailErrorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            emailErrorLabel.leftAnchor.constraint(equalTo: emailTextField.leftAnchor)
        ]
        NSLayoutConstraint.activate(emailErrorConstraints)
        
        let passwordTFConstraints = [
            passwwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 50)
        ]
        NSLayoutConstraint.activate(passwordTFConstraints)
        
        let passwordErrorConstraints = [
            passwordErrorLabel.topAnchor.constraint(equalTo: passwwordTextField.bottomAnchor, constant: 10),
            passwordErrorLabel.leftAnchor.constraint(equalTo: passwwordTextField.leftAnchor)
        ]
        NSLayoutConstraint.activate(passwordErrorConstraints)
        
        let signUpConstraints = [
            signupButton.topAnchor.constraint(equalTo: passwwordTextField.bottomAnchor, constant: 70),
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(signUpConstraints)
        
    }
    
    private func setupButtonAction() {
        signupButton.addAction(UIAction(handler: {[weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.RegisterNewUserWith(usernameTF: strongSelf.usernameTextField, usernameErrorLabel: strongSelf.usernameErrorLabel, emailTF: strongSelf.emailTextField, emailErrorLabel: strongSelf.emailErrorLabel, passwordTF: strongSelf.passwwordTextField, passwordErrorLabel: strongSelf.passwordErrorLabel)
        }), for: .touchUpInside)
    }
    
    // MARK: - Functionn
    
    private func validateTextfield() {
    }
    
}
// MARK: - Extensions
extension SignUpViewController: RegistrationViewModelOutPut {
    func RegistrationViewModelGoToWelcomeView(username: String) {
        let welcomeService: UserEmailVerificationService = AuthManager()
        let viewModel = WelcomeViewModel(VerificationService: welcomeService)
        let vc = WelcomeViewController(viewModel: viewModel)
        vc.username = username
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
