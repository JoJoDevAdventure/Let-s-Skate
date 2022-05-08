//
//  AddNewPostViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 26/04/2022.
//

import UIKit
import Lottie
import PhotosUI

class AddNewPostViewController: UIViewController {
    
    // MARK: - Properties
    
    var postLibraryPicker: PHPickerViewController?
    var postCameraPicker = UIImagePickerController()
    
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
    
    private let upPhotoAnimation: AnimationView = {
        let view = AnimationView()
        view.animation = Animation.named("upImageAnimation")
        view.contentMode = .scaleToFill
        view.loopMode = .loop
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let downPhotoAnimation: AnimationView = {
        let view = AnimationView()
        view.animation = Animation.named("upImageAnimation")
        view.contentMode = .scaleToFill
        view.loopMode = .loop
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let chosenImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.backgroundColor = .gray
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let bioHintLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tell us how you're doing %nickname% :"
        label.textColor = .black
        return label
    }()
    
    private let bioTextZone: UITextView = {
        let textf = UITextView()
        textf.translatesAutoresizingMaskIntoConstraints = false
        textf.allowsEditingTextAttributes = true
        textf.layer.borderWidth = 2
        textf.layer.cornerRadius = 5
        textf.autocorrectionType = .no
        textf.backgroundColor = UIColor().lightMainColor()
        textf.textColor = .black
        textf.layer.borderColor = UIColor().DarkMainColor().cgColor
        return textf
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
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
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
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
    
    let viewModel: NewPostViewModel
    
    init(viewModel: NewPostViewModel) {
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
        setupConstraints()
        setupGestures()
        setupCamera()
        setupLibraryConfig()
        setupButtons()
        viewModel.getCurrentUser()
        view.backgroundColor = UIColor().lightMainColor()
    }
    
    // MARK: - Set up
    
    private func setupSubviews() {
        view.addSubview(chosenImageView)
        view.addSubview(bioHintLabel)
        view.addSubview(bioTextZone)
        view.addSubview(upPhotoAnimation)
        view.addSubview(downPhotoAnimation)
        view.addSubview(cancelButton)
        view.addSubview(confirmButton)
    }
    
    private func setupConstraints() {
        
        upPhotoAnimation.play()
        let upPhotoAnimationConstraints = [
            upPhotoAnimation.bottomAnchor.constraint(equalTo: chosenImageView.topAnchor, constant: 14),
            upPhotoAnimation.widthAnchor.constraint(equalTo: chosenImageView.widthAnchor),
            upPhotoAnimation.centerXAnchor.constraint(equalTo: chosenImageView.centerXAnchor),
            upPhotoAnimation.heightAnchor.constraint(equalToConstant: 30),
        ]
        NSLayoutConstraint.activate(upPhotoAnimationConstraints)
        
        downPhotoAnimation.play()
        let downPhotoAnimationConstraints = [
            downPhotoAnimation.topAnchor.constraint(equalTo: chosenImageView.bottomAnchor, constant: -11),
            downPhotoAnimation.widthAnchor.constraint(equalTo: chosenImageView.widthAnchor),
            downPhotoAnimation.centerXAnchor.constraint(equalTo: chosenImageView.centerXAnchor),
            downPhotoAnimation.heightAnchor.constraint(equalToConstant: 30),
        ]
        NSLayoutConstraint.activate(downPhotoAnimationConstraints)
        
        let chosenImageConstraints = [
            chosenImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chosenImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120),
            chosenImageView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60),
            chosenImageView.heightAnchor.constraint(equalTo: chosenImageView.widthAnchor, constant: 50)
        ]
        NSLayoutConstraint.activate(chosenImageConstraints)
        
        let bioConstraints = [
            bioTextZone.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bioTextZone.widthAnchor.constraint(equalTo: chosenImageView.widthAnchor),
            bioTextZone.heightAnchor.constraint(equalToConstant: 100),
            bioTextZone.topAnchor.constraint(equalTo: chosenImageView.bottomAnchor, constant: 50)
        ]
        NSLayoutConstraint.activate(bioConstraints)
        
        let bioHintConstraints = [
            bioHintLabel.bottomAnchor.constraint(equalTo: bioTextZone.topAnchor, constant: -3),
            bioHintLabel.leftAnchor.constraint(equalTo: bioTextZone.leftAnchor)
        ]
        NSLayoutConstraint.activate(bioHintConstraints)
        
        let confirmButtonConstraints = [
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 90),
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110),
            confirmButton.widthAnchor.constraint(equalToConstant: 120),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(confirmButtonConstraints)
        
        let cancelButtonConstraints = [
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -90),
            cancelButton.bottomAnchor.constraint(equalTo: confirmButton.bottomAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 120),
            cancelButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(cancelButtonConstraints)
    }
    
    private func setupLibraryConfig() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        config.preferredAssetRepresentationMode = .automatic
        postLibraryPicker = PHPickerViewController(configuration: config)
        postLibraryPicker!.delegate = self
    }
    
    private func setupCamera() {
        let hasCam = UIImagePickerController.isSourceTypeAvailable(.camera)
        if hasCam {
            setupPickers()
        }
    }
       
    private func setupPickers() {
        postCameraPicker.sourceType = .camera
        postCameraPicker.delegate = self
        postCameraPicker.allowsEditing = false
    }
    
    private func setupGestures() {
        chosenImageView.isUserInteractionEnabled = true
        chosenImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPickerView)))
    }
    
    private func setupButtons() {
        cancelButton.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true)
        }), for: .touchUpInside)
        
        confirmButton.addAction(UIAction(handler: { _ in
            LoadingAnimationView().animateLoadingScreen(view: self.view, animation: self.loadingAnimation, isUploading: true)
            self.viewModel.uploadUserPost(post: self.chosenImageView, bio: self.bioTextZone.text)
        }), for: .touchUpInside)
    }
    
        // MARK: - Functions
    
    @objc func showPickerView() {
        AlertManager.shared.picPictureAlert(self, "Select profile picture.") {[weak self] pickingMod in
            if pickingMod == .camera {
                guard let strongSelf = self else { return }
                self?.navigationController?.pushViewController(strongSelf.postCameraPicker, animated: true)
            } else {
                guard let postLibraryPicker = self?.postLibraryPicker else {
                    return
                }
                self?.present(postLibraryPicker, animated: true)
            }
        }
    }
    
}
// MARK: - Extensions
extension AddNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.chosenImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddNewPostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        if let r = results.first {
            let item = r.itemProvider
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        if let newImage = image as? UIImage {
                            self.chosenImageView.image = newImage
                        } else {
                            //TODO ERROR TO LOAD IMAGE
                            guard let errorDesc = error?.localizedDescription else {
                                return
                            }
                            AlertManager.shared.showErrorAlert(viewcontroller: self, error: errorDesc)
                        }
                    }
                }
            }
        }
    }
}

extension AddNewPostViewController: NewPostViewModelOutPut {
    func showError(error: Error) {
        LoadingAnimationView().animateLoadingScreen(view: view, animation: loadingAnimation, isUploading: false)
        AlertManager().showErrorAlert(viewcontroller: self, error: error.localizedDescription as String)
    }
    
    func postUploadedWithSuccess() {
        LoadingAnimationView().animateLoadingScreen(view: view, animation: loadingAnimation, isUploading: false)
        NotificationCenter.default.post(name: NSNotification.Name("uploadedImageFetchUser"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func setUsername(username: String) {
        DispatchQueue.main.async {[weak self] in
            self?.bioHintLabel.text = "Tell us how you're doing \(username) :"
        }
    }
    
    func postHasNoPhotos() {
        LoadingAnimationView().animateLoadingScreen(view: view, animation: loadingAnimation, isUploading: false)
    }
}
