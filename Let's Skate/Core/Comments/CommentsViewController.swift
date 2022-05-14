//
//  CommentsViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 13/05/2022.
//

import UIKit

class CommentsViewController: UIViewController {
    
    var comments: [Comment] = []
    var isTyping = false
    
    // MARK: - Properties
    
    private let commentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        return tableView
    }()
    
    private let textFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor().DarkMainColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let commentTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: "Comment this post...",
            attributes : [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let sendCommentButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "paperplane", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 45))
        button.tintColor = UIColor().lightMainColor()
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let underTF: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        view.backgroundColor = UIColor().lightMainColor()
        view.layer.cornerRadius = 0.5
        return view
    }()
    
    private let noCommentsLabel: UILabel = {
        let label = UILabel()
        label.text = "No comments for now.\nBe the first to comment !"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - ViewModel
    
    let viewModel: CommentsViewModel
    
    init(viewModel: CommentsViewModel) {
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
        setupSubviews()
        setupTableView()
        setupNavBar()
        setupTextfield()
        setupConstraints()
        setupObserver()
        setupGesture()
        hideKeyBoard()
        fetchComments()
        setupSendButton()
    }
    
    
    // MARK: - Set up

    private func setupNavBar() {
        title = "Comments"
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = UIColor().DarkMainColor()
        navigationController?.navigationBar.barTintColor = UIColor().DarkMainColor()
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 31, weight: UIFont.Weight.bold) ]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold) ]
    }
    
    private func setupTextfield() {
        commentTextField.delegate = self
    }
    
    private func setupSubviews() {
        view.addSubview(commentsTableView)
        view.addSubview(textFieldView)
        textFieldView.addSubview(sendCommentButton)
        textFieldView.addSubview(underTF)
        textFieldView.addSubview(commentTextField)
        view.addSubview(noCommentsLabel)
    }
    
    private func setupTableView() {
        commentsTableView.backgroundColor = UIColor().DarkMainColor()
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
    }
    
    private func setupConstraints() {
        let constraints = [
            // textfield view
            textFieldView.widthAnchor.constraint(equalTo: view.widthAnchor),
            textFieldView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textFieldView.heightAnchor.constraint(equalToConstant: 100),
            
            // send button
            sendCommentButton.rightAnchor.constraint(equalTo: textFieldView.rightAnchor, constant: -30),
            sendCommentButton.centerYAnchor.constraint(equalTo: textFieldView.centerYAnchor, constant: -10),
            sendCommentButton.heightAnchor.constraint(equalToConstant: 25),
            sendCommentButton.widthAnchor.constraint(equalToConstant: 25),
            
            // underline
            underTF.widthAnchor.constraint(equalTo: textFieldView.widthAnchor, constant: -110),
            underTF.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -45),
            underTF.leftAnchor.constraint(equalTo: textFieldView.leftAnchor, constant: 20),
            
            // textfield
            commentTextField.widthAnchor.constraint(equalTo: underTF.widthAnchor, constant: -5),
            commentTextField.heightAnchor.constraint(equalToConstant: 50),
            commentTextField.centerXAnchor.constraint(equalTo: underTF.centerXAnchor, constant: 5),
            commentTextField.bottomAnchor.constraint(equalTo: underTF.topAnchor, constant: 5),
            
            // no comments label
            noCommentsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noCommentsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewDidLayoutSubviews() {
        commentsTableView.frame = view.bounds
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShown(_:)),name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillBeHidden(_:)),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShown(_ notification: NSNotification) {
        if !isTyping {
            print("show keyboard")
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
                    self.textFieldView.transform = self.textFieldView.transform.translatedBy(x: 0, y: -keyboardHeight+17)
                }
                isTyping.toggle()
            }
        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        if isTyping {
            print("hide keyboard")
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
                    self.textFieldView.transform = self.textFieldView.transform.translatedBy(x: 0, y: keyboardHeight-17)
                }
                isTyping.toggle()
            }
        }
    }
    
    private func setupGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard)))
    }
    
    @objc func hideKeyBoard() {
        commentTextField.endEditing(false)
        commentTextField.resignFirstResponder()
    }
    
    private func setupSendButton() {
        sendCommentButton.addAction(UIAction(handler: { _ in
            guard let comment = self.commentTextField.text else { return }
            self.viewModel.uploadComment(comment: comment)
            self.commentTextField.resignFirstResponder()
            self.commentTextField.text = ""
        }), for: .touchUpInside)
    }
    
    //MARK: - Functions
    
    private func fetchComments() {
        viewModel.fetchAllComments()
    }
    
    private func verifyIfThereAreComments() {
        if comments.isEmpty {
            noCommentsLabel.isHidden = false
        } else {
            noCommentsLabel.isHidden = true
        }
    }
    
}
// MARK: - Extensions
extension CommentsViewController :  UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier) as? CommentTableViewCell else { return UITableViewCell()
        }
        let currentComment = comments[indexPath.row]
        cell.configure(comment: currentComment)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

extension CommentsViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == "" {
            sendCommentButton.isEnabled = false
        } else {
            sendCommentButton.isEnabled = true
        }
    }
}

extension CommentsViewController : CommentsViewModelOutPut {
    
    func fetchComments(comments: [Comment]) {
        self.comments = comments
        DispatchQueue.main.async {
            self.commentsTableView.reloadData()
        }
        verifyIfThereAreComments()
    }
    
    func showError(error: Error) {
        AlertManager().showErrorAlert(viewcontroller: self, error: error.localizedDescription)
    }
}
