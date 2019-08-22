//
//  AccountController+fetchUserInfo.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/5/26.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase

extension AccountController {
    
    func fetchUserWorkout(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users-workout").child(uid).observe(.value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            self.workouts = [Workout]()
            
            for (key, value) in dictionary {
                let value = value as? [String: Any]
                let videoId = value?["videoId"] as? String
                let workout = Workout(day: key, videoId: videoId)
                self.workouts.append(workout)
            }
            
            DispatchQueue.main.async {
                self.workouts = self.workouts.sorted(by: {$0.dayOrder?.compare($1.dayOrder ?? 0) == .orderedAscending})
                self.collectionView.reloadData()
            }
        }, withCancel: nil)
    }
    
    func fetchUserName(){
        
        guard let uId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(uId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                self.user.email = dictionary["email"] as? String
                self.user.name = dictionary["name"] as? String
            }
            self.fetchUserData()
        }, withCancel: nil)
        
        ref.observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.user.profileImageUrl = dictionary["profileImageUrl"] as? String
            }
            self.handleReload()
            
        }, withCancel: nil)
    }
    
    private func fetchUserData(){
        guard let uId = Auth.auth().currentUser?.uid else { return }
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let date = "\(year)-\(month)"
        
        let ref = Database.database().reference().child("users-numberOfViews").child(uId).child(date)
        ref.observe(.value, with: { (snapshot) in
            
            if snapshot.exists(){
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let numberOfViews = dictionary["numberOfVideoViews"] as? Int
                    self.userNumberOfViews = "\(numberOfViews ?? 0)"
                }
            }else{
                self.userNumberOfViews = "0"
            }
            self.fetchUserLikes()
            
        }, withCancel: nil)
    }
    
    private func fetchUserLikes(){
        
        guard let uId = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("users-likeVideos").child(uId)
        ref.observe(.value, with: { (snapshot) in
            
            if snapshot.exists(){
                let numberOfLikes = Int(snapshot.childrenCount)
                self.userNumberOfLikes = "\(numberOfLikes)"
                
            }else{
                self.userNumberOfLikes = "0"
            }
            self.handleReload()
            
        }, withCancel: nil)
    }
    
}
