//
//  CategoryItemCells.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//


import UIKit

class CategoryCell: BaseCell {
    
    override var isHighlighted: Bool {
        
        didSet{
            backgroundColor = isHighlighted ? UIColor.rgb(red: 22, green: 171, blue: 47, alpha: 1) : UIColor.white
            
            categoriesLabel.textColor = isHighlighted ? UIColor.white : UIColor.darkGray
        }
    }
    
    let categoriesLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .left
        return label
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    override func setupViews() {
        
        addSubview(categoriesLabel)
        addSubview(seperatorView)
        
        categoriesLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        categoriesLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        categoriesLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        categoriesLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        seperatorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        seperatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seperatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }
    
}


