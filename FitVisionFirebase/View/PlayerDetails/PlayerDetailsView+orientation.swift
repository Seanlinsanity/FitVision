//
//  PlayerDetailsView_orientation.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/4/7.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

extension PlayerDetailsView{
    
    func handleRotation(){
        
        if UIDevice.current.orientation.isLandscape {
            UIApplication.shared.isStatusBarHidden = true
            handleLanscape()
        }
        if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            UIApplication.shared.isStatusBarHidden = false
            handleProtrait()
        }
    }
    
    private func handleLanscape(){
        
        panToMinimizePlayerGesture.isEnabled = false
        
        insertSubview(blackView, belowSubview: backView)
        blackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        blackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        deviceRotated(hideStatusBar: true)
        self.backViewHeightConstraint?.isActive = false
        if #available(iOS 11.0, *) {
            backViewBottomConstraint = backView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        } else {
            backViewBottomConstraint = backView.bottomAnchor.constraint(equalTo: bottomAnchor)
        }
        backViewBottomConstraint?.isActive = true
        
        collectionViewTopConstraint?.constant = frame.height
        playerFrontView.fullscreenWidth?.constant = 50
        playerFrontView.currentTimeLabelHeight?.constant = 24
        playerFrontView.currentTimeLabel.font = UIFont.systemFont(ofSize: 20)
        
        if video?.hour != nil {
            playerFrontView.durationLabelWidth?.constant = 90
            playerFrontView.currentTimeLabelWidth?.constant = 90
        }else{
            playerFrontView.durationLabelWidth?.constant = 70
            playerFrontView.currentTimeLabelWidth?.constant = 70
        }
        
        playerFrontView.durationLabelHeight?.constant = 24
        playerFrontView.durationLabel.font = UIFont.systemFont(ofSize: 20)
        playerFrontView.subtitleText.font = UIFont.boldSystemFont(ofSize: 18)
        playerFrontView.dissmissButton.isHidden = true
        setupSubtitleLabel()
        
    }
    
    private func handleProtrait(){
        
        panToMinimizePlayerGesture.isEnabled = true
        
        blackView.removeFromSuperview()
        
        deviceRotated(hideStatusBar: false)
        
        backViewBottomConstraint?.isActive = false
        backViewHeightConstraint?.isActive = true
        
        collectionViewTopConstraint?.constant = 0
        playerFrontView.fullscreenWidth?.constant = 30
        playerFrontView.currentTimeLabelHeight?.constant = 24
        playerFrontView.currentTimeLabel.font = UIFont.systemFont(ofSize: 16)
        
        if video?.hour != nil {
            playerFrontView.currentTimeLabelWidth?.constant = 75
            playerFrontView.durationLabelWidth?.constant = 75
        }else{
            playerFrontView.durationLabelWidth?.constant = 50
            playerFrontView.currentTimeLabelWidth?.constant = 50
            
        }
        playerFrontView.durationLabelHeight?.constant = 24
        playerFrontView.durationLabel.font = UIFont.systemFont(ofSize: 16)
        playerFrontView.subtitleText.font = UIFont.boldSystemFont(ofSize: 12)
        playerFrontView.dissmissButton.isHidden = false
        setupSubtitleLabel()
        
    }
    
    private func deviceRotated(hideStatusBar: Bool){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            appDelegate.deviceRotated(isStatusBarHidden: hideStatusBar)
        }
    }
    
}
