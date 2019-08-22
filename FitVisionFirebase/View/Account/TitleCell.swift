//
//  TitleCell.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/25.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class TitleCell : AccountSettingCell {
    
    var nameLabelleftAnchorConstraint: NSLayoutConstraint?
    var YAnchorConstraint: NSLayoutConstraint?
    
    override func cellSubviewLayout() {
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = .gray
        YAnchorConstraint = nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        YAnchorConstraint?.isActive = true
        nameLabelleftAnchorConstraint = nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40)
        nameLabelleftAnchorConstraint?.isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
}
