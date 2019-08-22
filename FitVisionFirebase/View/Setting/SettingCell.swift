//
//  SettingCell.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    
    override var isHighlighted: Bool {
        
        didSet{
            backgroundColor = isHighlighted ? UIColor.rgb(red: 22, green: 171, blue: 47, alpha: 1) : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.darkGray
            noteLabel.textColor = isHighlighted ? .white : .gray
        }
    }
    
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name.rawValue
            if let imageName = setting?.imageName {
                iconImageView.image = UIImage(named: imageName)
                nameLabel.textColor = UIColor.darkGray
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let noteLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .gray
        lb.font = UIFont.systemFont(ofSize: 18)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(red: 210, green: 210, blue: 210, alpha: 1)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        
        addSubview(nameLabel)
        addSubview(iconImageView)
        addSubview(noteLabel)
        addSubview(seperatorView)
        
        addConstraintsWithFormat(format: "H:|-32-[v0(30)]-12-[v1]|", views: iconImageView, nameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:[v0(20)]", views: iconImageView)
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        noteLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        noteLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        noteLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        noteLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        seperatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        seperatorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
}

