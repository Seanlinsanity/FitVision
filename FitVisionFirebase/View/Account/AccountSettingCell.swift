//
//  AccountSettingCell.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class AccountSettingCell: BaseCell {
    
    var accountSetting: AccountSetting? {
        didSet{
            
            nameLabel.text = accountSetting?.name
            
            if let imageName = accountSetting?.imageName{
                iconImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.rgb(red: 22, green: 171, blue: 47, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        
        cellSubviewLayout()
        
    }
    
    func cellSubviewLayout() {
        
        addSubview(nameLabel)
        addSubview(iconImageView)
        addSubview(seperatorView)
        
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        seperatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        seperatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 56).isActive = true
        seperatorView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}

