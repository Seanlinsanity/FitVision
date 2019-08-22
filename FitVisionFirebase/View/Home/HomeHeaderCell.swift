//
//  FeaturedHeaderCell.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/5/1.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class HomeHeaderCell: BaseCell {

    var video: Video?{
        didSet{
            if let imageUrl = video?.thumbnailImageUrl{
                thumbnailImageView.loadImageUsingUrlData(imageUrl)
            }
            titleLabel.text = video?.title
        }
    }

    
    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = UIColor.rgb(red: 200, green: 200, blue: 200, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let titleBackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "載入中..."
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(thumbnailImageView)
        thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        thumbnailImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        thumbnailImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        thumbnailImageView.addSubview(titleBackView)
        titleBackView.leftAnchor.constraint(equalTo: thumbnailImageView.leftAnchor).isActive = true
        titleBackView.rightAnchor.constraint(equalTo: thumbnailImageView.rightAnchor).isActive = true
        titleBackView.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor).isActive = true
        titleBackView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        titleBackView.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: titleBackView.leftAnchor, constant: 24).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: titleBackView.rightAnchor, constant: -24).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: titleBackView.bottomAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: titleBackView.heightAnchor).isActive = true
        
    }
}
