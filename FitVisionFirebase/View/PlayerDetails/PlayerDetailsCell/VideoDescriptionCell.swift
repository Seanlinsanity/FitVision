//
//  VideoDescriptionCell.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class VideoDescriptionCell: BaseCell {
        
    var videoDescription: String?{
        didSet{
            if let description = videoDescription{
                descriptionText.text = description
            }
        }
    }
    
    let descriptionText : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.textColor = .darkGray
        tv.text = "say something here............"
        return tv
    }()
    
    let border: UIView = {
        let border = UIView()
        border.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        border.translatesAutoresizingMaskIntoConstraints = false
        return border
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(descriptionText)
        addSubview(border)
        
        descriptionText.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        descriptionText.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        descriptionText.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        descriptionText.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        border.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        border.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        border.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
}

