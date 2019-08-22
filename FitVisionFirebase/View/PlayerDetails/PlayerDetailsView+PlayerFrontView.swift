//
//  PlayerDetailsView+PlayerFrontView.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/4/20.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

extension PlayerDetailsView: PlayerFrontViewDelegate{
    
    func handleFullScreen() {
        var value: Int?
        
        if UIDevice.current.orientation == UIDeviceOrientation.portrait{
            value = UIInterfaceOrientation.landscapeRight.rawValue
        }else{
            value = UIInterfaceOrientation.portrait.rawValue
        }
        UIDevice.current.setValue(value, forKey: "orientation")
        setupSubtitleLabel()
    }
    
    @objc func handlePausePlay() {
        if isPlaying {
            videoView.pauseVideo()
            playerFrontView.pausePlayButton.setImage(UIImage(named: "play"), for: UIControlState())
            miniPausePlayButton.setImage(UIImage(named: "play"), for: UIControlState())
            
        }else {
            videoView.playVideo()
            playerFrontView.pausePlayButton.setImage(UIImage(named: "pause"), for: UIControlState())
            miniPausePlayButton.setImage(UIImage(named: "pause"), for: UIControlState())
        }
        isPlaying = !isPlaying
    }
    
    func handleSliderChange() {
        let min = video?.min ?? "0"
        let sec = video?.sec ?? "0"
        let hour = video?.hour ?? "0"
        
        let totalSec = Float(hour)! * 3600 + Float(min)! * 60 + Float(sec)!
        let currentTime = playerFrontView.videoSlider.value * totalSec
        videoView.seek(toSeconds: currentTime, allowSeekAhead: true)
        
        handleCurrentLabelChange(currentTime: currentTime)
        
        video?.time = currentTime
        video?.setupSubtitles()
        setupSubtitleLabel()
    }
    
    private func handleCurrentLabelChange(currentTime: Float) {
        
        let secsString = String(format: "%02d", Int(Int(currentTime) % 60))
        
        if video?.hour != nil {
            
            if Int(currentTime) / 60 >= 60 {
                let minsString = String(format: "%02d", Int(Int(currentTime) % 3600 / 60))
                let hoursString = String(format: "%02d", Int(Int(currentTime) / 3600))
                playerFrontView.currentTimeLabel.text = "\(hoursString):\(minsString):\(secsString)"
            }else{
                let hoursString = "00"
                let minsString = String(format: "%02d", Int(Int(currentTime) / 60))
                playerFrontView.currentTimeLabel.text = "\(hoursString):\(minsString):\(secsString)"
            }
            
        }else{
            
            let minsString = String(format: "%02d", Int(Int(currentTime) / 60))
            playerFrontView.currentTimeLabel.text = "\(minsString):\(secsString)"
            
        }
    }
    
}
