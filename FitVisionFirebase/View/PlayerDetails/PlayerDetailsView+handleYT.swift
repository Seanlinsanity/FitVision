//
//  PlayerDetailsView_handleYT.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/4/5.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

extension PlayerDetailsView{
    
    func loadYouTubeVideo(){
        
        if let videoId = video?.videoId {
            videoView.load(withVideoId: videoId, playerVars: ["playsinline": 1, "showinfo": 0, "modestbranding": 0, "controls": 0, "rel": 0, "iv_load_policy": 3, "hl": "zu"])
            print(videoId)
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        
        videoView.alpha = 1
        
        playerView.cueVideo(byId: video!.videoId!, startSeconds: playerView.currentTime(), suggestedQuality: .medium)
        playerView.playVideo()
        
        setupPlayer()
        activityIndicatorView.stopAnimating()
        
        if let video = video {
            updateUserViewsInFirebase(video: video)
            updateVideoViewsInFirebase(video: video)
        }

    }
    
    private func setupPlayer() {
        if !isFirstLoading { return }

        backView.addSubview(playerFrontView)
        backView.backgroundColor = .white
        
        playerFrontView.topAnchor.constraint(equalTo: videoView.topAnchor).isActive = true
        playerFrontView.centerXAnchor.constraint(equalTo: videoView.centerXAnchor).isActive = true
        playerFrontView.widthAnchor.constraint(equalTo: videoView.widthAnchor).isActive = true
        playerFrontView.heightAnchor.constraint(equalTo: videoView.heightAnchor).isActive = true
        playerFrontView.addGestureRecognizer(panToMinimizePlayerGesture)
        
        isFirstLoading = false
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
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        if delegate.statusBarIsHidden{
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
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState){
        
        if state == YTPlayerState.playing{
            playerFrontView.pausePlayButton.setImage(UIImage(named: "pause"), for: UIControlState())
            playerFrontView.backgroundColor = .clear
            stopTimer()
            startTimer()
            
        }else if state == YTPlayerState.ended{
            playerFrontView.backgroundColor = .black
            playerFrontView.pausePlayButton.setImage(UIImage(named: "play"), for: UIControlState())
            isPlaying = false
            stopTimer()
            
        }else{
            playerFrontView.backgroundColor = .clear
            stopTimer()
            
        }
    }
    
    func startTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(handleTrackVideoCurrentTime), userInfo: nil, repeats: true)
        
    }
    
    fileprivate func handleTrackCurrentTimeLable() {
        
        let secs = videoView.currentTime() + 1
        let secsString = String(format: "%02d", Int(Int(secs) % 60))
        
        if video?.hour != nil {

            if Int(secs) / 60 >= 60 {
                let minsString = String(format: "%02d", Int(Int(secs) % 3600 / 60))
                let hoursString = String(format: "%02d", Int(Int(secs) / 3600))
                playerFrontView.currentTimeLabel.text = "\(hoursString):\(minsString):\(secsString)"
            }else{
                let hoursString = "00"
                let minsString = String(format: "%02d", Int(Int(secs) / 60))
                playerFrontView.currentTimeLabel.text = "\(hoursString):\(minsString):\(secsString)"
            }
            
        }else{
            let minsString = String(format: "%02d", Int(Int(secs) / 60))
            playerFrontView.currentTimeLabel.text = "\(minsString):\(secsString)"
        }
    }
    
    @objc private func handleTrackVideoCurrentTime(){
        
        video?.time = videoView.currentTime()
        video?.setupSubtitles()
        setupSubtitleLabel()
        playerFrontView.subtitleText.text = video?.subtitle
        
        handleTrackCurrentTimeLable()
        
        if let min = video?.min {
            if let sec = video?.sec {
                let hour = video?.hour ?? "0"
                let totalSec = Float(hour)! * 3600 + Float(min)! * 60 + Float(sec)!
                playerFrontView.videoSlider.value = videoView.currentTime() / totalSec
                
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
}
