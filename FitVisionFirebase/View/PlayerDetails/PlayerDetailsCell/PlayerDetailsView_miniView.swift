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
        
        backView.addSubview(miniPlayerView)
        miniPlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMiniPlayerViewTap)))
        miniPlayerView.topAnchor.constraint(equalTo: backView.topAnchor).isActive = true
        miniPlayerView.leftAnchor.constraint(equalTo: backView.leftAnchor).isActive = true
        miniPlayerView.rightAnchor.constraint(equalTo: backView.rightAnchor).isActive = true
        miniPlayerView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        miniPlayerView.isHidden = true
        
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
    
}
