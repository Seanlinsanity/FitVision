//
//  WorkoutCell.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/4/9.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class WorkoutCell: UITableViewCell{
    
    var workout: Workout?{
        didSet{
            dayLabel.text = workout?.day
            
            let videos = HomeApiService.sharedInstance.videos
            guard let index = videos.index(where: {$0.videoId == workout?.videoId}) else { return }
            let video = videos[index]
            titleLabel.text = video.title ?? ""
            if let url = video.thumbnailImageUrl {
                thumbnailImageView.loadImageUsingUrlData(url)
            }
        }
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.darkGreen.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let dayLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "週一"
        lb.textAlignment = .center
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        lb.backgroundColor = UIColor.darkGreen
        return lb
    }()
    
    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .black
        lb.numberOfLines = 0
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 36).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -36).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        containerView.addSubview(dayLabel)
        dayLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        dayLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dayLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        dayLabel.widthAnchor.constraint(equalToConstant: 55).isActive = true
        
        containerView.addSubview(thumbnailImageView)
        thumbnailImageView.leftAnchor.constraint(equalTo: dayLabel.rightAnchor, constant: 8).isActive = true
        thumbnailImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalToConstant: (60 - 8) * 16 / 9).isActive = true
        
        containerView.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
