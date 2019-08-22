//
//  CustomTabBarContoller_playerAnimation.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/4/7.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

extension CustomTabBarController{
    
    func maximizePlayerDetails(video: Video?){
        AppUtility.lockOrientation(.allButUpsideDown)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRotation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        if video != nil{
            playerDetailsView.video = video
        }
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 0
            
        }, completion: nil)
        
    }
    
    func minimizePlayerDetails(){
        AppUtility.lockOrientation(.portrait)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 1
            
        }, completion: nil)
        
        playerDetailsView.minimizeVideoView()
        
    }
    
    func dimissPlayerDetails(){
        
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        
        maximizedTopAnchorConstraint.constant = view.frame.height
        bottomAnchorConstraint.constant = view.frame.height
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    @objc private func handleRotation(){
        playerDetailsView.handleRotation()
    }
    
}
