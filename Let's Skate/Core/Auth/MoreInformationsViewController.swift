//
//  MoreInformationsViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 29/04/2022.
//

import UIKit
import PhotosUI

class MoreInformationsViewController: UIViewController {
    
    // MARK: - Properties
    
    var profileLibraryPicker: PHPickerViewController?
    var profileCameraPicker = UIImagePickerController()
    var bannerLibraryPicker: PHPickerViewController?
    var bannerCameraPicker = UIImagePickerController()
    var canUseCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
    
    private let moreInformationsLabel: UILabel = {
        let label = UILabel()
        label.text = "Tell us more about you!"
        label.font = .systemFont(ofSize: 36, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bannerImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "skateBannerBackground")
        image.backgroundColor = .gray
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "skateProfileImageBackground")
        image.backgroundColor = .gray
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let nickNameTextField: AuthTextfield = {
        let tf = AuthTextfield()
        tf.placeholder = "Nickname 👽"
        return tf
    }()
    
    private let bioText: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 120).isActive = true
        tf.widthAnchor.constraint(equalToConstant: 280).isActive = true
        tf.textColor = .white
        tf.layer.borderWidth = 1.5
        tf.layer.borderColor = UIColor.white.cgColor
        tf.backgroundColor = UIColor.init(white: 1, alpha: 0.1)
        tf.textAlignment = .center
        tf.layer.shadowColor = UIColor.black.cgColor
        tf.layer.shadowRadius = 3
        tf.layer.shadowOpacity = 1
        tf.layer.shadowOffset = CGSize(width: 2, height: 2)
        tf.layer.cornerRadius = 10
        tf.attributedPlaceholder = NSAttributedString(
            string: "XXXXXXXXXXXXX",
            attributes : [NSAttributedString.Key.foregroundColor: UIColor.white])
        tf.placeholder = "Tell peoples more about you !"
        return tf
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
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
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Confirm", for: .normal)
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
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        setupGestureReconizers()
        setupLibraryConfig()
        setupCamera()
        setupButtons()
    }
    
    // MARK: - Set up
    
    private func setupSubviews() {
        view.isUserInteractionEnabled = true
        view.addSubview(bannerImageView)
        view.addSubview(profileImageView)
        view.addSubview(moreInformationsLabel)
        view.addSubview(nickNameTextField)
        view.addSubview(bioText)
        view.addSubview(confirmButton)
        view.addSubview(cancelButton)
    }
    
    private func setupConstraints() {
        let tellUsMoreLabelConstraints = [
            moreInformationsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            moreInformationsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        ]
        NSLayoutConstraint.activate(tellUsMoreLabelConstraints)
        
        let bannerImageConstraints = [
            bannerImageView.topAnchor.constraint(equalTo: moreInformationsLabel.bottomAnchor, constant: 40),
            bannerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            bannerImageView.heightAnchor.constraint(equalTo: bannerImageView.widthAnchor, multiplier: 1/3),
        ]
        NSLayoutConstraint.activate(bannerImageConstraints)
        
        let profileImageConstraints = [
            profileImageView.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant:  -60),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor)
        ]
        profileImageView.layer.cornerRadius = (view.frame.width * 0.3)/2
        NSLayoutConstraint.activate(profileImageConstraints)
        
        let nicknameTFConstraints = [
            nickNameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 60),
            nickNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(nicknameTFConstraints)
        
        let bioTFConstraints = [
            bioText.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor, constant: 30),
            bioText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        NSLayoutConstraint.activate(bioTFConstraints)
        
        let confirmButtonConstraints = [
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
            confirmButton.widthAnchor.constraint(equalToConstant: 150),
        ]
        NSLayoutConstraint.activate(confirmButtonConstraints)
        
        let cancelButtonConstraints = [
            cancelButton.bottomAnchor.constraint(equalTo: confirmButton.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 150),
        ]
        NSLayoutConstraint.activate(cancelButtonConstraints)
    }
    
    private func setupGestureReconizers() {
        profileImageView.isUserInteractionEnabled = true
        let profileImageTap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
        profileImageView.addGestureRecognizer(profileImageTap)
        bannerImageView.isUserInteractionEnabled = true
        let bannerImageTap = UITapGestureRecognizer(target: self, action: #selector(didTapBannerImage))
        bannerImageView.addGestureRecognizer(bannerImageTap)
    }
    
    func setupLibraryConfig() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        config.preferredAssetRepresentationMode = .automatic
        profileLibraryPicker = PHPickerViewController(configuration: config)
        profileLibraryPicker!.delegate = self
        bannerLibraryPicker = PHPickerViewController(configuration: config)
        bannerLibraryPicker!.delegate = self
    }
    
    func setupCamera() {
        let hasCam = UIImagePickerController.isSourceTypeAvailable(.camera)
        if hasCam {
            setupPickers()
        }
    }
    
    func setupPickers() {
        profileCameraPicker.sourceType = .camera
        profileCameraPicker.delegate = self
        profileCameraPicker.allowsEditing = false
        bannerCameraPicker.sourceType = .camera
        bannerCameraPicker.delegate = self
        bannerCameraPicker.allowsEditing = false
    }
    
    private func setupButtons() {
        confirmButton.addAction(UIAction(handler: { _ in
            self.animateImage(imageView: self.bannerImageView)
        }), for: .touchUpInside)
    }
    
    // MARK: - Functions
    
    @objc func didTapProfileImage() {
        AlertManager.shared.picPictureAlert(self, "Select profile picture.") {[weak self] pickingMod in
            if pickingMod == .camera {
                guard let strongSelf = self else { return }
                self?.present(strongSelf.profileCameraPicker, animated: true)
            } else {
                guard let profileLibraryPicker = self?.profileLibraryPicker else {
                    return
                }
                self?.present(profileLibraryPicker, animated: true)
            }
        }
    }
    
    @objc func didTapBannerImage() {
        AlertManager.shared.picPictureAlert(self, "Select banner picture.") {[weak self] pickingMod in
            if pickingMod == .camera {
                guard let strongSelf = self else { return }
                self?.present(strongSelf.bannerCameraPicker, animated: true)
            } else {
                guard let bannerLibraryPicker = self?.bannerLibraryPicker else {
                    return
                }
                self?.present(bannerLibraryPicker, animated: true)
            }
        }
    }
    
    func animateImage(imageView: UIImageView) {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.bannerImageView.backgroundColor = .red
            self.bannerImageView.backgroundColor = .gray
            self.bannerImageView.backgroundColor = .red
            self.bannerImageView.backgroundColor = .gray
        }
    }
    
}
// MARK: - Extensions

extension MoreInformationsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if picker == bannerCameraPicker {
            if let image = info[.originalImage] as? UIImage {
                self.bannerImageView.image = image
            }
        }
        if picker == profileCameraPicker {
            if let image = info[.originalImage] as? UIImage {
                self.profileImageView.image = image
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension MoreInformationsViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if picker == profileLibraryPicker {
            picker.dismiss(animated: true, completion: nil)
            if let r = results.first {
                let item = r.itemProvider
                if item.canLoadObject(ofClass: UIImage.self) {
                    item.loadObject(ofClass: UIImage.self) { image, error in
                        DispatchQueue.main.async {
                            if let newImage = image as? UIImage {
                                self.profileImageView.image = newImage
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
        } else if picker == bannerLibraryPicker {
            picker.dismiss(animated: true, completion: nil)
            if let r = results.first {
                let item = r.itemProvider
                if item.canLoadObject(ofClass: UIImage.self) {
                    item.loadObject(ofClass: UIImage.self) { image, error in
                        DispatchQueue.main.async {
                            if let newImage = image as? UIImage {
                                self.bannerImageView.image = newImage
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
}
