//
//  AddNewPostViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 26/04/2022.
//

import UIKit
import Lottie

class AddNewPostViewController: UIViewController {

    // MARK: - Properties
    
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
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        view.backgroundColor = UIColor().lightMainColor()
    }
    

    // MARK: - Set up
    
    private func setupSubviews() {
        view.addSubview(chosenImageView)
        view.addSubview(bioHintLabel)
        view.addSubview(bioTextZone)
        view.addSubview(upPhotoAnimation)
        view.addSubview(downPhotoAnimation)
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
        
    }
    
    // MARK: - Functions
    
    
}
// MARK: - Extensions
