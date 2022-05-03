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
    
    var isUploading = false
    
    func updateUserInformations(view: UIView, loadingAnimation: AnimationView,bannerImage: UIImageView, profileImage: UIImageView, nickname: String?, bio: String?) {
        
        let bannerImage = bannerImage.image
        let profileImage = profileImage.image
        
        isUploading = true
        animateLoadingScreen(view: view, animation: loadingAnimation)
        
        service.addUserInformations(bannerImage: bannerImage, profileImage: profileImage, nickname: nickname, bio: bio) {[weak self] results in
            switch results {
            case .success(()) :
                self?.output?.informationsUploadedSuccesfully()
                self?.isUploading = false
                self?.animateLoadingScreen(view: view, animation: loadingAnimation)
            case .failure(let error):
                self?.output?.errorUploadingInformations(error: error)
                self?.animateLoadingScreen(view: view, animation: loadingAnimation)
            }
        }
    }
    
    func imageError(bannerImage: UIImageView, profileImage: UIImageView) -> Bool {
        if bannerImage.image == UIImage(named: "skateBannerBackground") {
            ImageErrorAnimations().animateImage(imageView: bannerImage)
            return false
        }
        
        if profileImage.image == UIImage(named: "skateProfileImageBackground") {
            ImageErrorAnimations().animateImage(imageView: profileImage)
            return false
        }
        return true
    }
    
    func animateLoadingScreen(view: UIView, animation: AnimationView) {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 0.7
        let upView = UIView()
        if isUploading == true {
            //upview
            upView.translatesAutoresizingMaskIntoConstraints = false
            upView.backgroundColor = .clear
            view.addSubview(upView)
            NSLayoutConstraint.activate([
              upView.topAnchor.constraint(equalTo: view.topAnchor),
              upView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              upView.heightAnchor.constraint(equalTo: view.heightAnchor),
              upView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
            //blur
            blurView.translatesAutoresizingMaskIntoConstraints = false
            upView.insertSubview(blurView, at: 0)
            NSLayoutConstraint.activate([
              blurView.topAnchor.constraint(equalTo: upView.topAnchor),
              blurView.leadingAnchor.constraint(equalTo: upView.leadingAnchor),
              blurView.heightAnchor.constraint(equalTo: upView.heightAnchor),
              blurView.widthAnchor.constraint(equalTo: upView.widthAnchor)
            ])
            //animation
            view.addSubview(animation)
            animation.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            animation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            animation.play()
        } else {
            upView.removeFromSuperview()
            animation.removeFromSuperview()
        }
    }
    
}
