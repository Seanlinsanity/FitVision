//
//  VideoPlayer_handleYT.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import Firebase

extension VideoPlayerController {
    
    private func setupPlayer() {
        
        backView.addSubview(videoView)
        backView.addSubview(playerFrontView)
        
        videoView.topAnchor.constraint(equalTo: backView.topAnchor).isActive = true
        videoView.leftAnchor.constraint(equalTo: backView.leftAnchor).isActive = true
        videoView.rightAnchor.constraint(equalTo: backView.rightAnchor).isActive = true
        videoView.heightAnchor.constraint(equalTo: backView.heightAnchor).isActive = true

        
        playerFrontView.topAnchor.constraint(equalTo: videoView.topAnchor).isActive = true
        playerFrontView.centerXAnchor.constraint(equalTo: videoView.centerXAnchor).isActive = true
        playerFrontView.widthAnchor.constraint(equalTo: videoView.widthAnchor).isActive = true
        playerFrontView.heightAnchor.constraint(equalTo: videoView.heightAnchor).isActive = true
        
        backView.layoutSubviews()
        //playerFrontView.gradientLayer.frame = playerFrontView.frame
        
        setupVideoDuration()
        //checkSubtitleAvailable()
    }
    
//    fileprivate func checkSubtitleAvailable(){
//        if video?.subtitleArray == nil {
//            playerFrontView.handleSubtitleButton.isEnabled = false
//        }
//    }
    
    fileprivate func setupVideoDuration() {
        
        if video?.hour != nil{
            playerFrontView.durationLabelWidth?.constant = 75
            playerFrontView.durationLabel.text = "\(video?.hour ?? "00"):\(video?.min ?? "00"):\(video?.sec ?? "00")"
            
            playerFrontView.currentTimeLabelWidth?.constant = 75
            playerFrontView.currentTimeLabel.text = "00:00:00"
            
        }else{
            playerFrontView.durationLabel.text = "\(video?.min ?? "00"):\(video?.sec ?? "00")"
            playerFrontView.currentTimeLabel.text = "00:00"
        }
        
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        
        playerView.cueVideo(byId: video!.videoId!, startSeconds: playerView.currentTime(), suggestedQuality: .medium)
        playerView.playVideo()
        
        setupPlayer()
        activityIndicatorView.stopAnimating()
        isPlaying = true
        
        if let watchVideo = video {
            updateUserViewsInFirebase(video: watchVideo)
            updateVideoViewsInFirebase(video: watchVideo)
        }
        
        preferStop()
        
    }
    
    private func preferStop() {
        
        if toStop == true {
            videoView.stopVideo()
            isPlaying = false
            playerFrontView.pausePlayButton.setImage(UIImage(named: "play"), for: UIControlState())
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
    
    private func updateUserViewsInFirebase(video: Video) {
        
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
    
    private func updateVideoViewsInFirebase(video: Video){
        
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

