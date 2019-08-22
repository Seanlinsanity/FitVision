//
//  VideoCell.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class VideoCell: BaseCell{
    
    var video: Video? {
        didSet {
            
            setupThumbnailImage()
            setupProfileImage()
            setupDurationLabel()
            setupTag()
            
            if let numberOfViews = video?.numberOfViews{
                setupNumberOfViews(numberOfViews: numberOfViews)
            }
            
            if let channel = video?.channel?.name {
                channelName.text = channel
            }
            
            if let title = video?.title {
                titleLabel.text = title
                setupVideoTitle(title: title)
            }
            
        }
    }
    
    private func setupTag(){
        guard let categories = video?.categories else { return }
        if categories.count > 1{
            difficultytagLabel.text = categories[0]
            if categories[0] == "初階"{
                difficultytagLabel.backgroundColor = UIColor.lightGreen
            }else if categories[0] == "進階"{
                difficultytagLabel.backgroundColor = UIColor.mainGreen
            }else{
                difficultytagLabel.backgroundColor = UIColor.darkGreen
            }
            categoryTagLabel.text = categories[1]
            categoryTagLabelWidth?.constant = categories[1].count > 3 ? 100 : 80
        }
    }
    
    func setupNumberOfViews(numberOfViews: NSNumber){
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let size = CGSize(width: 2000, height: 20)  //width is just an large arbitary
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let numberOfViews = "\(numberFormatter.string(from: numberOfViews) ?? "載入中")"
        viewCountLabel.text = numberOfViews
        
        let estimatedRect = NSString(string: numberOfViews).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)], context: nil)
        viewCountLabelWidth?.constant = estimatedRect.width + 4
        
    }
    
    func setupVideoTitle(title: String){
        //measure the title text
        let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000) //height is a large abitrary
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
        
        
        if estimatedRect.size.height > 25 {
            titleLabelHeightConstraint?.constant = 44
        }else{
            titleLabelHeightConstraint?.constant = 25
        }
    }
    
    private func setupDurationLabel(){
        if video?.hour == nil {
            durationLabelWidth?.constant = 50
        }else{
            durationLabelWidth?.constant = 75
        }
        durationLabel.text = video?.setupDuration()        
    }
    
    func setupProfileImage(){
        if let profileImageUrl = video?.channel?.profileImageUrl {
            userProfileImageView.loadImageUsingUrlData(profileImageUrl)
        }
    }
    
    func setupThumbnailImage() {
        if let thumbnailImageUrl = video?.thumbnailImageUrl {
            thumbnailImageView.loadImageUsingUrlData(thumbnailImageUrl)
        }
    }
    
    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = UIColor.rgb(red: 200, green: 200, blue: 200, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "載入中..."
        label.numberOfLines = 2
        return label
    }()
    
    let channelName: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "載入中..."
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor.gray
        return textView
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.layer.cornerRadius = 4
        label.backgroundColor = UIColor(white: 0, alpha: 0.7)
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "00:00"
        return label
    }()
    
    let viewCountImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "play")?.withRenderingMode(.alwaysTemplate)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.rgb(red: 22, green: 171, blue: 47, alpha: 1)
        return imageView
    }()
    
    let viewCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "載入中..."
        return label
    }()
    
    let difficultytagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.mainGreen
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 12.5
        label.layer.masksToBounds = true
        return label
    }()
    
    let categoryTagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.orange
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 12.5
        label.layer.masksToBounds = true
        return label
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    var viewCountLabelWidth: NSLayoutConstraint?
    var durationLabelWidth: NSLayoutConstraint?
    var categoryTagLabelWidth: NSLayoutConstraint?
    
    override func setupViews(){
        super.setupViews()
        
        backgroundColor = .white
        addSubview(thumbnailImageView)
        addSubview(seperatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(viewCountLabel)
        addSubview(channelName)
        addSubview(durationLabel)
        addSubview(viewCountImageView)
        addSubview(difficultytagLabel)
        addSubview(categoryTagLabel)
        
        thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        thumbnailImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -32).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 9/16).isActive = true
        
        userProfileImageView.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor).isActive = true
        userProfileImageView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        seperatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        seperatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        seperatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        durationLabel.rightAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: -4).isActive = true
        durationLabel.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: -4).isActive = true
        durationLabelWidth = durationLabel.widthAnchor.constraint(equalToConstant: 50)
        durationLabelWidth?.isActive = true
        durationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        viewCountImageView.centerYAnchor.constraint(equalTo: viewCountLabel.centerYAnchor).isActive = true
        viewCountImageView.rightAnchor.constraint(equalTo: viewCountLabel.leftAnchor, constant: 2).isActive = true
        viewCountImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        viewCountImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        viewCountLabel.topAnchor.constraint(equalTo: channelName.topAnchor).isActive = true
        viewCountLabel.rightAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: -8).isActive = true
        viewCountLabelWidth = viewCountLabel.widthAnchor.constraint(equalToConstant: 60)
        viewCountLabelWidth?.isActive = true
        viewCountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        difficultytagLabel.topAnchor.constraint(equalTo: channelName.bottomAnchor, constant: 4).isActive = true
        difficultytagLabel.leftAnchor.constraint(equalTo: channelName.leftAnchor).isActive = true
        difficultytagLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        difficultytagLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        categoryTagLabel.topAnchor.constraint(equalTo: difficultytagLabel.topAnchor).isActive = true
        categoryTagLabel.leftAnchor.constraint(equalTo: difficultytagLabel.rightAnchor, constant: 8).isActive = true
        categoryTagLabel.heightAnchor.constraint(equalTo: difficultytagLabel.heightAnchor).isActive = true
        categoryTagLabelWidth = categoryTagLabel.widthAnchor.constraint(equalToConstant: 80)
        categoryTagLabelWidth?.isActive = true

        //top constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        //left constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        //right constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        //height constraint
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 44)
        addConstraint(titleLabelHeightConstraint!)
        
        addConstraint(NSLayoutConstraint(item: channelName, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        addConstraint(NSLayoutConstraint(item: channelName, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        
        addConstraint(NSLayoutConstraint(item: channelName, attribute: .right, relatedBy: .equal, toItem: viewCountLabel, attribute: .left, multiplier: 1, constant: -30))
        addConstraint(NSLayoutConstraint(item: channelName, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
    }
}


