//
//  PlayerDetailsView_miniView.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/4/6.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

extension PlayerDetailsView{
    
    func setupMiniPlayerView(){
        
        backView.insertSubview(miniPlayerView, belowSubview: videoView)
        miniPlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMiniPlayerViewTap)))
        miniPlayerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanUp)))
        
        miniPlayerView.topAnchor.constraint(equalTo: backView.topAnchor).isActive = true
        miniPlayerView.leftAnchor.constraint(equalTo: backView.leftAnchor).isActive = true
        miniPlayerView.rightAnchor.constraint(equalTo: backView.rightAnchor).isActive = true
        miniPlayerView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        miniPlayerView.isHidden = true
        
        setupMiniPlayerViewUI()
    }
    
    private func setupMiniPlayerViewUI(){
        miniPlayerView.addSubview(miniDissmissButton)
        miniDissmissButton.rightAnchor.constraint(equalTo: miniPlayerView.rightAnchor, constant: -8).isActive = true
        miniDissmissButton.centerYAnchor.constraint(equalTo: miniPlayerView.centerYAnchor).isActive = true
        miniDissmissButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        miniDissmissButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        miniPlayerView.addSubview(miniPausePlayButton)
        miniPausePlayButton.rightAnchor.constraint(equalTo: miniDissmissButton.leftAnchor, constant: -8).isActive = true
        miniPausePlayButton.centerYAnchor.constraint(equalTo: miniPlayerView.centerYAnchor).isActive = true
        miniPausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        miniPausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        miniPlayerView.addSubview(miniTitle)
        miniTitle.leftAnchor.constraint(equalTo: miniPlayerView.leftAnchor, constant: 8 + 57 * 16 / 9 + 4).isActive = true
        miniTitle.rightAnchor.constraint(equalTo: miniPausePlayButton.leftAnchor, constant: -8).isActive = true
        miniTitle.topAnchor.constraint(equalTo: miniPlayerView.topAnchor).isActive = true
        miniTitle.bottomAnchor.constraint(equalTo: miniPlayerView.bottomAnchor).isActive = true
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        
        miniPlayerView.addSubview(seperatorView)
        seperatorView.topAnchor.constraint(equalTo: miniPlayerView.topAnchor).isActive = true
        seperatorView.leadingAnchor.constraint(equalTo: miniPlayerView.leadingAnchor).isActive = true
        seperatorView.trailingAnchor.constraint(equalTo: miniPlayerView.trailingAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    @objc func handleMiniPlayerViewTap(){
        UIApplication.mainTabBarController()?.maximizePlayerDetails(video: nil)
        maximizeVideoView()
    }
    
    @objc func handleMiniPlayerPanUp(gesture: UIPanGestureRecognizer){
        
        if gesture.state == .changed{
            handlePanChanged(gesture: gesture)
        }else if gesture.state == .ended{
            handlePanEnded(gesture: gesture)
        }
        
    }
    
    @objc func handlePlayerViewPanDown(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)

        if gesture.state == .changed{
            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
            [videoView, backView, collectionView].forEach({$0.alpha = 1 - translation.y / 700})
            
        }else if gesture.state == .ended{
            self.transform = .identity
            [videoView, backView, collectionView].forEach({$0.alpha = 1})
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                if translation.y > 200 || velocity.y > 500{
                    UIApplication.mainTabBarController()?.minimizePlayerDetails()
                }
                
            }, completion: nil)
        }
    }
    
    @objc private func handlePanUp(gesture: UIPanGestureRecognizer){
            
        if gesture.state == .changed{
            handlePanChanged(gesture: gesture)
        }else if gesture.state == .ended{
            handlePanEnded(gesture: gesture)
        }
    }
    
    @objc func handlePanChanged(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
    }
    
    @objc func handlePanEnded(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.transform = .identity
            
            if translation.y < -100 || velocity.y < -500 {
                self.handleMiniPlayerViewTap()
            }
            
        }, completion: nil)
    }
        
    func maximizeVideoView(){
        
        videoViewTopConstraint?.constant = 0
        videoViewleftConstraint?.constant = 0
        videoViewWidthConstraint?.isActive = false
        videoViewWidthConstraint = videoView.widthAnchor.constraint(equalTo: backView.widthAnchor)
        videoViewWidthConstraint?.isActive = true
        videoViewHeightConstraint?.isActive = false
        videoViewHeightConstraint = videoView.heightAnchor.constraint(equalTo: backView.heightAnchor)
        videoViewHeightConstraint?.isActive = true
        
        miniPlayerView.isHidden = true
        playerFrontView.subviews.forEach({ $0.isHidden = false })
        playerFrontView.removeGestureRecognizer(tapToMaximizePlayerGesture)
        playerFrontView.removeGestureRecognizer(panToMaximizePlayerGesture)
        playerFrontView.addGestureRecognizer(panToMinimizePlayerGesture)
        
        collectionView.alpha = 1
        backView.backgroundColor = .white
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)

    }
    
    func minimizeVideoView(){
        
        videoViewTopConstraint?.constant = 4
        videoViewleftConstraint?.constant = 8
        videoViewWidthConstraint?.isActive = false
        videoViewWidthConstraint = videoView.widthAnchor.constraint(equalToConstant: 57 * 16 / 9)
        videoViewWidthConstraint?.isActive = true
        videoViewHeightConstraint?.isActive = false
        videoViewHeightConstraint = videoView.heightAnchor.constraint(equalToConstant: 57)
        videoViewHeightConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        
        miniPlayerView.isHidden = false
        playerFrontView.subviews.forEach({ $0.isHidden = true })
        playerFrontView.addGestureRecognizer(tapToMaximizePlayerGesture)
        playerFrontView.removeGestureRecognizer(panToMinimizePlayerGesture)
        playerFrontView.addGestureRecognizer(panToMaximizePlayerGesture)
        
        collectionView.alpha = 0
        backView.backgroundColor = .clear
        
    }
    
}
