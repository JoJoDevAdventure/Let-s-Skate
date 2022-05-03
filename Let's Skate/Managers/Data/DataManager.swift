//
//  DataManager.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 02/05/2022.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

protocol AddMoreInformationsService {
    func addUserInformations(bannerImage : UIImage?, profileImage : UIImage?, nickname: String?, bio: String?, completion: @escaping (Result<Void, Error>) -> Void )
}

class DataManager : AddMoreInformationsService {
    
    let currentUser = Auth.auth().currentUser
    let imageUploadService: ImageUploader
    
    init(imageUploadService: ImageUploader) {
        self.imageUploadService = imageUploadService
    }
    
    let storeRef = Firestore.firestore()
    
    func addUserInformations(bannerImage : UIImage?, profileImage : UIImage?, nickname: String?, bio: String?, completion: @escaping(Result<Void, Error>) -> Void ) {
        guard let uid = currentUser?.uid else { return }
        
        //default data if user press "later" button
        if bannerImage == nil {
            storeRef.collection("users")
                .document(uid)
                .updateData(["bannerImageUrl" : ProfileBannerUrl().bannerImageUrl])
        }
        if profileImage == nil {
            storeRef.collection("users")
                .document(uid)
                .updateData(["profileImageUrl" : ProfileBannerUrl().profileImageUrl])
        }
        if nickname == nil {
            let username = storeRef.collection("users")
                .document(uid)
                .value(forKey: "username")
            
            storeRef.collection("users")
                .document(uid)
                .setData(["nickname":username ?? ""])
        }
        if bio == nil {
            storeRef.collection("users")
                .document(uid)
                .setData(["bio" : ""])
        }
        
        //user data
        guard let bannerImage = bannerImage else {
            return
        }
        
        imageUploadService.uploadBannerImage(image: bannerImage) {[weak self] results in
            switch results {
            case.success(let url) :
                self?.storeRef.collection("users")
                    .document(uid)
                    .setData(["bannerImageUrl":url])
            case .failure(let error) :
                completion(.failure(error))
                break
            }
        }
        
        guard let profileImage = profileImage else {
            return
        }
        
        imageUploadService.uploadProfileImage(image: profileImage) {[weak self] results in
            switch results {
            case .success(let url) :
                self?.storeRef.collection("users")
                    .document(uid)
                    .setData(["profileImageUrl" : url])
            case .failure(let error) :
                completion(.failure(error))
                break
            }
        }
        
        //set nickname
        guard let nickname = nickname else {
            return
        }
        storeRef.collection("users")
            .document(uid)
            .setData(["nickname": nickname])
        
        //set bio
        guard let bio = bio else {
            return
        }
        storeRef.collection("users")
            .document(uid)
            .setData(["bio" : bio])
        
        completion(.success(()))
    }
}
