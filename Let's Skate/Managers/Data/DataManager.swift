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

protocol AddMoreInformations {
    
}

class DataManager : AddMoreInformations {
    
    let currentUser = Auth.auth().currentUser
    let imageUploadService: ImageUploader
    
    init(imageUploadService: ImageUploader) {
        self.imageUploadService = imageUploadService
    }
    
    let storeRef = Firestore.firestore()
    
    func addUserInformations(bannerImage : UIImage?, profileImage : UIImage?, nickname: String?, bio: String?) {
        guard let uid = currentUser?.uid else { return }
        
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
            storeRef.collection("users")
                .document(uid)
                .value(forKey: "username")
            
        }
    }
    
}
