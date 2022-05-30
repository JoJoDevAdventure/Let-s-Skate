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
    
    func updateUserInformations(view: UIView, loadingAnimation: AnimationView, bannerImage: UIImageView, profileImage: UIImageView, nickname: String?, bio: String?) {
        
        let bannerImage = bannerImage.image
        let profileImage = profileImage.image
        
        isUploading = true
        LoadingAnimationView().animateLoadingScreen(view: view, animation: loadingAnimation, isUploading: true)
        
        service.addUserInformations(bannerImage: bannerImage, profileImage: profileImage, nickname: nickname, bio: bio) {[weak self] results in
            switch results {
            case .success(()) :
                self?.output?.informationsUploadedSuccesfully()
                LoadingAnimationView().animateLoadingScreen(view: view, animation: loadingAnimation, isUploading: false)
            case .failure(let error):
                self?.output?.errorUploadingInformations(error: error)
                LoadingAnimationView().animateLoadingScreen(view: view, animation: loadingAnimation, isUploading: false)
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
    
    func userLeftWithoutMoreInformation() {
        
    }
    
}
