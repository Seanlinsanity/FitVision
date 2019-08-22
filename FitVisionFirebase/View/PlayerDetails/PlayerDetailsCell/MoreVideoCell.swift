//
//  MoreVideoCell.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class RecommendVideoTitleCell: BaseCell {
    
    let recommendLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "你可能會喜歡"
        label.textColor = .gray
        
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(recommendLabel)
        recommendLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        recommendLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        recommendLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        recommendLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
}

class MoreVideoCell: BaseCell {
    
    var video: Video? {
        
        didSet{
            
            videoTitle.text = video?.title
            channelTitle.text = video?.channel?.name
            setupTagLabel()
            
            if let thumbnailImageUrl = video?.thumbnailImageUrl{
                
                thumbnailImageView.loadImageUsingUrlData(thumbnailImageUrl)
            }
            setupDurationLabel()
        }
    }
    
    fileprivate func setupTagLabel() {
        tagLabel.text = video?.categories[0]
        if video?.categories[0] == "初階"{
            tagLabel.backgroundColor = UIColor.rgb(red: 28, green: 217, blue: 60, alpha: 1)
        }else if video?.categories[0] == "進階"{
            tagLabel.backgroundColor = UIColor.mainGreen
        }else{
            tagLabel.backgroundColor = UIColor.rgb(red: 14, green: 113, blue: 31, alpha: 1)
        }
    }
    
    private func setupDurationLabel(){
        if video?.hour == nil {
            durationLabelWidth?.constant = 40
        }else{
            durationLabelWidth?.constant = 60
        }
        durationLabel.text = video?.setupDuration()
    }
    
    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    let videoTitle: UILabel = {
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 18)
        title.numberOfLines = 2
        return title
        
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.layer.cornerRadius = 4
        label.backgroundColor = UIColor(white: 0, alpha: 0.7)
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "00:00"
        return label
    }()
    
    let channelTitle: UILabel = {
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 15)
        title.text = "FitVision is awesome"
        title.textColor = .gray
        return title
        
    }()
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.rgb(red: 22, green: 171, blue: 47, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "初階"
        label.textColor = .white
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        return label
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    var durationLabelWidth: NSLayoutConstraint?
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        
        addSubview(thumbnailImageView)
        addSubview(durationLabel)
        addSubview(videoTitle)
        addSubview(channelTitle)
        addSubview(tagLabel)
        addSubview(seperatorView)
        
        let width = (self.frame.height - 24) * 16 / 9
        
        thumbnailImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        durationLabel.rightAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: -4).isActive = true
        durationLabel.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: -4).isActive = true
        durationLabelWidth = durationLabel.widthAnchor.constraint(equalToConstant: 40)
        durationLabelWidth?.isActive = true
        durationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        videoTitle.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 8).isActive = true
        videoTitle.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        videoTitle.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        videoTitle.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        channelTitle.topAnchor.constraint(equalTo: videoTitle.bottomAnchor, constant: 4).isActive = true
        channelTitle.leftAnchor.constraint(equalTo: videoTitle.leftAnchor).isActive = true
        channelTitle.rightAnchor.constraint(equalTo: videoTitle.rightAnchor).isActive = true
        channelTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        tagLabel.topAnchor.constraint(equalTo: channelTitle.bottomAnchor, constant: 4).isActive = true
        tagLabel.leftAnchor.constraint(equalTo: channelTitle.leftAnchor).isActive = true
        tagLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        tagLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        seperatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        seperatorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
}

