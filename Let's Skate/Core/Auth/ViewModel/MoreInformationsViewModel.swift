//
//  MoreInformationsViewModel.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 02/05/2022.
//

import Foundation
import UIKit
import Lottie

protocol MoreInformationsViewModelOutPut : AnyObject {
    func informationsUploadedSuccesfully()
    
    func errorUploadingInformations(error: Error)
}

class MoreInformationsViewModel {
        
    weak var output: MoreInformationsViewModelOutPut?
    let service: AddMoreInformationsService
    
    init(service: AddMoreInformationsService) {
        self.service = service
    }
    
    var uploaded = false
    
    func updateUserInformations(bannerImage: UIImageView, profileImage: UIImageView, nickname: String?, bio: String?) {
        
        let bannerImage = bannerImage.image
        let profileImage = profileImage.image
        
        service.addUserInformations(bannerImage: bannerImage, profileImage: profileImage, nickname: nickname, bio: bio) {[weak self] results in
            switch results {
            case .success(()) :
                self?.output?.informationsUploadedSuccesfully()
                self?.uploaded = true
            case .failure(let error):
                self?.output?.errorUploadingInformations(error: error)
            }
        }
        
    }
    
    func showImageError(bannerImage: UIImageView, profileImage: UIImageView) {
        if bannerImage.image == UIImage(named: "skateBannerBackground") {
            ImageErrorAnimations().animateImage(imageView: bannerImage)
        }
        
        if profileImage.image == UIImage(named: "skateProfileImageBackground") {
            ImageErrorAnimations().animateImage(imageView: profileImage)
        }
    }
    
    func animateLoadingScreen(view: UIView,animation: AnimationView) {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        while uploaded == false {
            view.addSubview(animation)
            //blur
            view.backgroundColor = .clear
            blurView.translatesAutoresizingMaskIntoConstraints = false
            view.insertSubview(blurView, at: 0)
            NSLayoutConstraint.activate([
              blurView.topAnchor.constraint(equalTo: view.topAnchor),
              blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
              blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
            //animation
            animation.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            animation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            animation.play()
        }
        animation.removeFromSuperview()
        blurView.removeFromSuperview()
    }
    
}
