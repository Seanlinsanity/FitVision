//
//  VideoPlayer_HandleOrientation.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

extension VideoPlayerController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if UIDevice.current.orientation.isLandscape{
            
            DispatchQueue.main.async {
                
                self.navigationController?.isNavigationBarHidden = true
                self.tabBarController?.tabBar.isHidden = true
                //self.deviceRotated()
                self.backViewHeightConstraint?.isActive = false
                
                if #available(iOS 11.0, *) {
                    self.backViewBottomConstraint = self.backView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
                } else {
                    self.backViewBottomConstraint = self.backView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                }
                self.backViewBottomConstraint?.isActive = true
            
                //self.playerFrontView.gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.collectionViewTopConstraint?.constant = self.view.frame.height
                self.playerFrontView.fullscreenWidth?.constant = 50
                self.playerFrontView.currentTimeLabelHeight?.constant = 24
                self.playerFrontView.currentTimeLabel.font = UIFont.systemFont(ofSize: 20)
                
                if self.video?.hour != nil {
                    self.playerFrontView.durationLabelWidth?.constant = 90
                    self.playerFrontView.currentTimeLabelWidth?.constant = 90
                }else{
                    self.playerFrontView.durationLabelWidth?.constant = 70
                    self.playerFrontView.currentTimeLabelWidth?.constant = 70
                }
                
                self.playerFrontView.durationLabelHeight?.constant = 24
                self.playerFrontView.durationLabel.font = UIFont.systemFont(ofSize: 20)
                self.playerFrontView.subtitleText.font = UIFont.boldSystemFont(ofSize: 18)
                self.setupSubtitleLabel()
                
            }
        }
        
        if UIDevice.current.orientation.isPortrait{
            
            DispatchQueue.main.async {
               
                self.navigationController?.isNavigationBarHidden = false
                self.tabBarController?.tabBar.isHidden = false
                //self.deviceRotated()
                
                self.backViewBottomConstraint?.isActive = false
                self.backViewHeightConstraint?.isActive = true
                self.backView.layoutSubviews()
                
                //self.playerFrontView.gradientLayer.frame = self.playerFrontView.frame
                self.playerFrontView.layer.layoutSublayers()

                self.collectionViewTopConstraint?.constant = self.view.frame.width * 9 / 16
                self.playerFrontView.fullscreenWidth?.constant = 30
                self.playerFrontView.currentTimeLabelHeight?.constant = 24
                self.playerFrontView.currentTimeLabel.font = UIFont.systemFont(ofSize: 16)
                
                if self.video?.hour != nil {
                    self.playerFrontView.currentTimeLabelWidth?.constant = 75
                    self.playerFrontView.durationLabelWidth?.constant = 75
                }else{
                    self.playerFrontView.durationLabelWidth?.constant = 50
                    self.playerFrontView.currentTimeLabelWidth?.constant = 50

                }
                self.playerFrontView.durationLabelHeight?.constant = 24
                self.playerFrontView.durationLabel.font = UIFont.systemFont(ofSize: 16)
                self.playerFrontView.subtitleText.font = UIFont.boldSystemFont(ofSize: 12)
                self.setupSubtitleLabel()
                
            }
        }
    }
    
//    private func deviceRotated(){
//        guard let isNaviagtionHidden = navigationController?.isNavigationBarHidden else { return }
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
//            appDelegate.deviceRotated(isNavigationHidden: isNaviagtionHidden)
//        }
//    }
    
    func handleFullScreen(){
        
        var value: Int?
        guard let navigation = navigationController else { return }
        if navigation.isNavigationBarHidden{
            value = UIInterfaceOrientation.portrait.rawValue
        }else{
            value = UIInterfaceOrientation.landscapeRight.rawValue
        }
        UIDevice.current.setValue(value, forKey: "orientation")
        setupSubtitleLabel()
    }
    
    func setupSubtitleLabel(){
        
        if let text = video?.subtitle {
            if text == ""{
                playerFrontView.subtitleTextHeightConstraint?.constant = 0
            }else{
                checkOrientationForSubtitle(text: text)
            }
        }
    }
    
    private func checkOrientationForSubtitle(text: String){
        
        guard let navigation = navigationController else { return }
        if navigation.isNavigationBarHidden{
            let size = CGSize(width: 1000, height: 40) //width is a large abitrary
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedRect = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)], context: nil)
            
            if estimatedRect.size.width > 500 {
                playerFrontView.subtitleTextHeightConstraint?.constant = 50
                playerFrontView.subtitleTextWidthConstraint?.constant = 450
            }else{
                playerFrontView.subtitleTextHeightConstraint?.constant = 30
                playerFrontView.subtitleTextWidthConstraint?.constant = estimatedRect.size.width + 24
            }
            
        }else{
            let size = CGSize(width: 1000, height: 20)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedRect = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12)], context: nil)
            
            if estimatedRect.size.width > 300 {
                playerFrontView.subtitleTextHeightConstraint?.constant = 35
                playerFrontView.subtitleTextWidthConstraint?.constant = 250
            }else{
                playerFrontView.subtitleTextHeightConstraint?.constant = 20
                playerFrontView.subtitleTextWidthConstraint?.constant = estimatedRect.size.width + 12
            }
        }
    }
    
    func showDescription() {
        descriptionIsHidden = !descriptionIsHidden
        
        if let description = video?.videoDescription {
            let size = CGSize(width: view.frame.width - 32, height: 100000) //height is a large abitrary
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedRect = NSString(string: description).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], context: nil)
            
            if !descriptionIsHidden {
                descriptionCellHeight = estimatedRect.height + 72
            }else{
                descriptionCellHeight = 0
            }
        }
        
        let indexPath = IndexPath(item: 1, section: 0)
        collectionView.reloadItems(at: [indexPath])
    }
    
}

