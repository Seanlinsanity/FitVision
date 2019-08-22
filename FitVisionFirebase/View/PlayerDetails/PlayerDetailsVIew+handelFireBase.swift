//
//  PlayerDetailsVIew_handelFireBase.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/4/6.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase

extension PlayerDetailsView{
 
    func updateUserViewsInFirebase(video: Video) {
        
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let date = "\(year)-\(month)"
        
        let userViewsRef = Database.database().reference().child("users-numberOfViews").child(uId).child(date)
        userViewsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists() {
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let numberOfViews = dictionary["numberOfVideoViews"] as? Int
                    let newNumberOfViews = (numberOfViews ?? 0) + 1
                    let viewsValues = ["numberOfVideoViews" : newNumberOfViews] as [String : Any]
                    userViewsRef.updateChildValues(viewsValues, withCompletionBlock: { (err, viewsRef) in
                        if err != nil {
                            print(err ?? "user views update error")
                        }
                    })
                }
                
            }else{
                
                let viewsValues = ["numberOfVideoViews" : 1]
                userViewsRef.updateChildValues(viewsValues, withCompletionBlock: { (err, viewsRef) in
                    if err != nil {
                        print(err ?? "user views update error")
                    }
                })
            }
            
        }, withCancel: nil)
    }
    
    func updateVideoViewsInFirebase(video: Video){
        
        guard let videoId = video.videoId else { return }
        
        let videoViewsRef = Database.database().reference().child("videos-numberOfViews").child(videoId)
        videoViewsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists() {
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let numberOfViews = dictionary["numberOfViews"] as? Int
                    let newNumberOfViews = (numberOfViews ?? 0) + 1
                    let viewsValues = ["numberOfViews" : newNumberOfViews] as [String : Any]
                    videoViewsRef.updateChildValues(viewsValues, withCompletionBlock: { (err, viewsRef) in
                        if err != nil {
                            print(err ?? "video views update error")
                        }
                    })
                }
                
            }else{
                
                let viewsValues = ["numberOfViews" : 1]
                videoViewsRef.updateChildValues(viewsValues, withCompletionBlock: { (err, viewsRef) in
                    if err != nil {
                        print(err ?? "video views update error")
                    }
                })
            }
            
        }, withCancel: nil)
    }
    
}
