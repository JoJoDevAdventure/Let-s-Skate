//
//  sideViewButtonView.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 20/04/2022.
//

import UIKit

class sideViewButtonView: UIView {
    
    // MARK: - Properties
    
    private let buttonImage: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()
    
    private let buttonText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "xxxxxxxxxx"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let devider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor().lightMainColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.5
        return view
    }()
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

    
    // MARK: - Set up
    
    private func setupSubviews() {
        addSubview(buttonImage)
        addSubview(buttonText)
        addSubview(devider)
    }
    
    private func setupConstraints() {
        
        let imageConstraints = [
            buttonImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonImage.widthAnchor.constraint(equalToConstant: 30),
            buttonImage.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(imageConstraints)
        
        let textConstraints = [
            buttonText.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 3),
            buttonText.leadingAnchor.constraint(equalTo: buttonImage.trailingAnchor, constant: 10)
            
        ]
        NSLayoutConstraint.activate(textConstraints)
        
        let deviderConstraints = [
            devider.centerXAnchor.constraint(equalTo: centerXAnchor),
            devider.widthAnchor.constraint(equalTo: widthAnchor, constant:  -10),
            devider.heightAnchor.constraint(equalToConstant: 1),
            devider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(deviderConstraints)
        
    }
    
    func configureButton(with imageName: String, _ text: String) {
        buttonImage.image = UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 15))
        buttonText.text = text
    }

}
