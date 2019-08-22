//
//  LoveUserCell.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/3/15.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class LoveUserCell: BaseCell {
    
    var user: UserModel?{
        
        didSet{
            nameLabel.text = user?.name
            if user?.profileImageUrl == nil {
                userProfileImage.image = nil
                nameAbbreviationLabel.text = user?.userAbbreviation
            }
            
            guard let imageUrl = user?.profileImageUrl else { return }
            userProfileImage.loadImageUsingUrlData(imageUrl)
            nameAbbreviationLabel.text = nil
            
        }
    }
    
    let userProfileImage: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 50
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let nameAbbreviationLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)

        addSubview(userProfileImage)
        userProfileImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        userProfileImage.topAnchor.constraint(equalTo: topAnchor, constant: 32).isActive = true
        userProfileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        userProfileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(nameLabel)
        
        nameLabel.centerXAnchor.constraint(equalTo: userProfileImage.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: 8).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(nameAbbreviationLabel)
        nameAbbreviationLabel.centerXAnchor.constraint(equalTo: userProfileImage.centerXAnchor).isActive = true
        nameAbbreviationLabel.centerYAnchor.constraint(equalTo: userProfileImage.centerYAnchor).isActive = true
        nameAbbreviationLabel.widthAnchor.constraint(equalTo: userProfileImage.widthAnchor).isActive = true
        nameAbbreviationLabel.heightAnchor.constraint(equalTo: userProfileImage.heightAnchor).isActive = true
        
    }
}
