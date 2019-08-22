//
//  HomeController_handleNotification.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/4/20.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

extension HomeController{
    
    func playVideoWithNotification(videoId: String){
        notificationTimer?.invalidate()
        notificationTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(checkFetchingNotificationVideo), userInfo: videoId, repeats: true)
    }
    
    @objc private func checkFetchingNotificationVideo(_ timer: Timer){
        
        let videoId = timer.userInfo as? String
        let videoIndex = allVideos?.index{$0.videoId == videoId}
        guard let index = videoIndex else { return }
        
        let notificationVideo = allVideos?[index]
        if notificationVideo?.channel?.profileImageUrl == nil {
            return
        }else{
            notificationTimer?.invalidate()
        }
        
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController
        mainTabBarController?.maximizePlayerDetails(video: notificationVideo)
        
    }
    
}
