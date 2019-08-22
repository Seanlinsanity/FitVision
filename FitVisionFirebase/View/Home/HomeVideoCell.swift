//
//  FeaturedVideoCell.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/5/1.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class HomeVideoCell: UICollectionViewCell {
    
    var video: Video?{
        didSet{
            
            if let imageUrl = video?.thumbnailImageUrl{
                thumbImageView.loadImageUsingUrlData(imageUrl)
                shimmerThumbnailImageView.removeFromSuperview()
            }
            
            if video?.title != nil{
                videoTitle.backgroundColor = .clear
                shimmerTitleLabel.removeFromSuperview()
            }
            
            videoTitle.text = video?.title
            channelLabel.text = video?.channel?.name
            
            setupDifficultyTag()
            setupDurationLabel()
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
    
    private func setupDifficultyTag(){
        guard let categories = video?.categories else { return }
        if categories.count > 1{
            difficultyTagLabel.text = categories[0]
            if categories[0] == "初階"{
                difficultyTagLabel.backgroundColor = UIColor.lightGreen
            }else if categories[0] == "進階"{
                difficultyTagLabel.backgroundColor = UIColor.mainGreen
            }else{
                difficultyTagLabel.backgroundColor = UIColor.darkGreen
            }
        }
    }
    
    let videoTitle: UILabel = {
        let lb = UILabel()
        lb.text = "Title here"
        lb.numberOfLines = 2
        lb.backgroundColor = UIColor.rgb(red: 200, green: 200, blue: 200, alpha: 1)
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.layer.cornerRadius = 4
        lb.clipsToBounds = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let channelLabel: UILabel = {
        let lb = UILabel()
        lb.text = "channel here"
        lb.textColor = .gray
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
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
    
    let difficultyTagLabel: UILabel = {
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
    
    let thumbImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = UIColor.rgb(red: 200, green: 200, blue: 200, alpha: 1)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 4
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let shimmerThumbnailImageView: CustomImageView = {
        let view = CustomImageView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let shimmerTitleLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let imageViewGradientLayerMask: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.45, 0.55, 1]

        return gradientLayer
    }()
    
    let titleLabelGradientLayerMask: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.45, 0.55, 1]

        return gradientLayer
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var durationLabelWidth: NSLayoutConstraint?
    
    func setupViews(){
        addSubview(thumbImageView)
        addSubview(videoTitle)
        addSubview(channelLabel)
        addSubview(difficultyTagLabel)
        
        thumbImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        thumbImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        thumbImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        thumbImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 5/9).isActive = true
        
        thumbImageView.addSubview(durationLabel)
        durationLabel.rightAnchor.constraint(equalTo: thumbImageView.rightAnchor, constant: -4).isActive = true
        durationLabel.bottomAnchor.constraint(equalTo: thumbImageView.bottomAnchor, constant: -4).isActive = true
        durationLabelWidth = durationLabel.widthAnchor.constraint(equalToConstant: 40)
        durationLabelWidth?.isActive = true
        durationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        videoTitle.topAnchor.constraint(equalTo: thumbImageView.bottomAnchor, constant: 2).isActive = true
        videoTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        videoTitle.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        videoTitle.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        setupImageViewShimmerMask()
        
        channelLabel.topAnchor.constraint(equalTo: videoTitle.bottomAnchor, constant: 2).isActive = true
        channelLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        channelLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        channelLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        difficultyTagLabel.topAnchor.constraint(equalTo: channelLabel.bottomAnchor, constant: 4).isActive = true
        difficultyTagLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        difficultyTagLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        difficultyTagLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    fileprivate func setupImageViewShimmerMask(){
        thumbImageView.addSubview(shimmerThumbnailImageView)
        shimmerThumbnailImageView.topAnchor.constraint(equalTo: thumbImageView.topAnchor).isActive = true
        shimmerThumbnailImageView.bottomAnchor.constraint(equalTo: thumbImageView.bottomAnchor).isActive = true
        shimmerThumbnailImageView.leftAnchor.constraint(equalTo: thumbImageView.leftAnchor).isActive = true
        shimmerThumbnailImageView.rightAnchor.constraint(equalTo: thumbImageView.rightAnchor).isActive = true
        
        videoTitle.addSubview(shimmerTitleLabel)
        shimmerTitleLabel.topAnchor.constraint(equalTo: videoTitle.topAnchor).isActive = true
        shimmerTitleLabel.bottomAnchor.constraint(equalTo: videoTitle.bottomAnchor).isActive = true
        shimmerTitleLabel.leftAnchor.constraint(equalTo: videoTitle.leftAnchor).isActive = true
        shimmerTitleLabel.rightAnchor.constraint(equalTo: videoTitle.rightAnchor).isActive = true
        
        layoutIfNeeded()
        
        shimmerThumbnailImageView.layer.mask = imageViewGradientLayerMask
        imageViewGradientLayerMask.frame = shimmerThumbnailImageView.frame
        imageViewGradientLayerMask.frame.size = CGSize(width: 400, height: 300)
        
        shimmerTitleLabel.layer.mask = titleLabelGradientLayerMask
        titleLabelGradientLayerMask.frame = shimmerTitleLabel.frame
        titleLabelGradientLayerMask.frame.size = CGSize(width: 400, height: 300)
        
        let angle = -75 * CGFloat.pi / 180
        imageViewGradientLayerMask.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        titleLabelGradientLayerMask.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        setupShimmerAnimation()
    }
    
    fileprivate func setupShimmerAnimation(){
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -200
        animation.toValue = 100
        animation.repeatCount = Float.infinity
        animation.duration = 2
        
        imageViewGradientLayerMask.add(animation, forKey: "animationKey")
        titleLabelGradientLayerMask.add(animation, forKey: "animationKey")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

