//
//  SignInViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 22/04/2022.
//

import UIKit

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    // header
    private let headerView: AuthHeaderView = {
        let view = AuthHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 320).isActive = true
        view.setup(first: "Hello.", second: "Welcome Back!")
        return view
    }()
    
    // background photo
    private let backgroundPhoto: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "SignInBackgroound")
        return image
    }()
    
    // email TF
    private let emailTextField: AuthTextfield = {
        let textfield = AuthTextfield()
        textfield.placeholder = "E-mail"
        return textfield
    }()
    
    // passsword TF
    private let passwordTextField: AuthTextfield = {
        let textfield = AuthTextfield()
        textfield.placeholder = "Password"

        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    // SignIn Button
    private let signinButton: AuthButton = {
        let button = AuthButton()
        button.setTitle("Sign In", for: .normal)
        return button
    }()
    
    // SignUp Label
    private let signupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 18)
        label.text = "Not member yet?"
        return label
    }()
    
    // SignUp
    private let signupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.setTitle("YES.", for: .selected)
        return button
    }()
    
    // mail error label
    private let emailErrorLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    // password error label
    private let passwordErrorLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()

    // MARK: - ViewModel
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel){
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
        setupSignupButton()
        setupSignInButton()
        setupTextfield()
        setupGestures()
    }
    
    // MARK: - Set up
    // adding subviews
    private func setupSubView() {
        view.addSubview(backgroundPhoto)
        view.addSubview(headerView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signinButton)
        view.addSubview(signupLabel)
        view.addSubview(signupButton)
        view.addSubview(emailErrorLabel)
        view.addSubview(passwordErrorLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundPhoto.frame = view.bounds
    }
    
    // signup action
    private func setupSignupButton() {
        signupButton.addAction(UIAction(handler: { _ in
            let registrationService : RegistrationService = AuthManager()
            let viewModel = RegistrationViewModel(registrationService: registrationService)
            let vc = SignUpViewController(viewModel: viewModel)
            self.present(vc, animated: true)
        }), for: .touchUpInside)
    }
    
    // sign in action
    private func setupSignInButton() {
        signinButton.addAction(UIAction(handler: { _ in
            self.emailErrorLabel.isHidden = true
            self.passwordErrorLabel.isHidden = true
            guard let email = self.emailTextField.text else { return }
            guard let password = self.passwordTextField.text else { return }
            self.resignKeyboard()
            let valid = self.viewModel.validateTextField(emailTF: self.emailTextField, passwordTF: self.passwordTextField)
            if valid {
                self.viewModel.logInUser(email: email,password: password)
            }
        }), for: .touchUpInside)
    }
    
    // Setup TF
    private func setupTextfield() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // Constraints
    private func setupConstraints() {
        
        let headerViewConstraints = [
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: -100),
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 100),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant:  -100),
        ]
        NSLayoutConstraint.activate(headerViewConstraints)
        
        let emailTFConstraints = [
            emailTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 70),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(emailTFConstraints)
        
        let passwordTFConstraints = [
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 70)
        ]
        NSLayoutConstraint.activate(passwordTFConstraints)
        
        let signinButtonConstraints = [
            signinButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 90),
            signinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(signinButtonConstraints)
        
        let signupLabelConstraints = [
            signupLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            signupLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -24)
        ]
        NSLayoutConstraint.activate(signupLabelConstraints)

        let signupButtonConstraints = [
            signupButton.leftAnchor.constraint(equalTo: signupLabel.rightAnchor, constant: 6),
            signupButton.topAnchor.constraint(equalTo: signupLabel.topAnchor, constant: -7)
        ]
        NSLayoutConstraint.activate(signupButtonConstraints)
        
        let emailErrorLabelConstraints = [
            emailErrorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5),
            emailErrorLabel.leftAnchor.constraint(equalTo: emailTextField.leftAnchor, constant: 5)
        ]
        NSLayoutConstraint.activate(emailErrorLabelConstraints)
        
        let passwordErrorLabelConstraints = [
            passwordErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5),
            passwordErrorLabel.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor, constant: 5)
        ]
        NSLayoutConstraint.activate(passwordErrorLabelConstraints)
    }
    
    // SetupGesture
    private func setupGestures() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboard)))
    }
    
    // MARK: - Functions
    @objc private func resignKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}

// MARK: - Extensions
extension SignInViewController: LoginViewModelOutPut {
    func switchToFeedViewController() {
        let vc = mainNavigationBar()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func LoginError(error: LoginErrors) {
        DispatchQueue.main.async {[self] in
            switch error {
                // badly formated email
            case .emailNotFormated:
                TextFieldErrorAnimation().textfieldAnimation(textfield: emailTextField)
                emailErrorLabel.isHidden = false
                emailErrorLabel.text = error.description
                
                // email doesn't exists
            case .FIRAuthErrorCodeInvalidEmail:
                TextFieldErrorAnimation().textfieldAnimation(textfield: emailTextField)
                emailErrorLabel.isHidden = false
                emailErrorLabel.text = error.description
                
                // user disabled
            case .FIRAuthErrorCodeUserDisabled:
                AlertManager().showErrorAlert(viewcontroller: self, error: error.description)
                
                // wrond password
            case .FIRAuthErrorCodeWrongPassword:
                TextFieldErrorAnimation().textfieldAnimation(textfield: passwordTextField)
                passwordErrorLabel.isHidden = false
                passwordErrorLabel.text = error.description
                
                // unknown error
            case .FIRAuthErrorCodeUnkown:
                AlertManager().showErrorAlert(viewcontroller: self, error: error.description)
            }
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}
