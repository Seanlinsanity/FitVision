//
//  NoResultCell.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/22.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class noResultsCell: BaseCell {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "抱歉，找不到相符的搜尋結果"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 120).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
}
