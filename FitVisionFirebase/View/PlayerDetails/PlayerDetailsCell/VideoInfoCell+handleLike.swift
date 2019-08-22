//
//  VideoInfoCell_handleLike.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase

extension VideoInfoCell {
    
    func readUserLike(uid : String) {
        
        if let videoId = self.video?.videoId{
            readUserLikesVideoInFirebase(videoId: videoId, uid: uid)
        }
    }
    
    fileprivate func readUserLikesVideoInFirebase(videoId: String ,uid : String){
        
        userLikeVideos = [String]()
        
        let likeRef = Database.database().reference().child("users-likeVideos").child(uid)
        
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists(){
                
                let numberOflikes = Int(snapshot.childrenCount)
        
                likeRef.observe(.childAdded, with: { (snapshot) in
                    let userLikeVideoId = snapshot.key
                    
                    self.userLikeVideos.append(userLikeVideoId)
                    self.checkIfLike(videoId: videoId, numberOflikes: numberOflikes, ref: likeRef)
                    
                }, withCancel: nil)
                
            }else{
                
                self.isLiked = false
                print("user don't like any videos")
                DispatchQueue.main.async {
                    self.setupLikeButton()
                }
                
            }
        }, withCancel: nil)
    }
    
    fileprivate func checkIfLike(videoId: String, numberOflikes: Int, ref: DatabaseReference) {

        if self.userLikeVideos.count == numberOflikes {
            
            if self.userLikeVideos.contains(videoId) == false {
                isLiked = false
                
                DispatchQueue.main.async {
                    self.setupLikeButton()
                }
                
            }else{
                isLiked = true
                
                DispatchQueue.main.async {
                    self.setupLikeButton()
                }
            }
        }
    }
    
    @objc func handleLike() {
        
        guard let updated_isLiked = isLiked , let uid = Auth.auth().currentUser?.uid else {
            isLiked = false
            setupLikeButton()
            
            Alert.showBasicAlert(title: "錯誤", message: "請先登入會員。", vc: UIApplication.mainTabBarController()!)

            return
        }
        
        guard let videoId = video?.videoId else { return }
        
        if updated_isLiked != true {
            let likeValues = ["addLikeDate": Date().timeIntervalSince1970] as [String : AnyObject]
            let likeRef = Database.database().reference().child("users-likeVideos").child(uid)
            likeRef.child(videoId).updateChildValues(likeValues, withCompletionBlock: { (error, ref) in
                
                if error != nil{
                    let alert = UIAlertController(title: "錯誤", message: "操作失敗，請檢查網路連線。", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "關閉", style: .default, handler: nil))
                    UIApplication.mainTabBarController()?.present(alert, animated: true, completion: nil)
                }
                self.isLiked = true
                
                DispatchQueue.main.async {
                    self.setupLikeButton()
                }
            })
            
        }else{
            
            let likeRef = Database.database().reference().child("users-likeVideos").child(uid).child(videoId)
            likeRef.removeValue(completionBlock: { (err, ref) in
                
                if err != nil {
                    print("remove like error")
                    return
                }
                self.isLiked = false
                
                DispatchQueue.main.async {
                    self.setupLikeButton()
                }
            })
        }
    }
    
    @objc func handleShare(){
        
        guard let videoId = video?.videoId else { return }
        guard let url = URL(string: "https://www.youtube.com/watch?v=\(videoId)") else { return }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.mainTabBarController()?.present(activityVC, animated: true, completion: nil)
        
    }
    
}

