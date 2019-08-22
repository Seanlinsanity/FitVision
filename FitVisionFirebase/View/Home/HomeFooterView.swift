//
//  HomeFooterView.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/5/13.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

protocol FooterMoreCategoriesDelegate {
    func handleMoreCategories()
}

class HomeFooterView: UICollectionReusableView{
    
    var delegate: FooterMoreCategoriesDelegate?
    
    lazy var moreButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .mainGreen
        btn.setTitle("更多分類", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(handleMoreCategoryVideos), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(moreButton)
        moreButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        moreButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        moreButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        moreButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    @objc private func handleMoreCategoryVideos(){
        delegate?.handleMoreCategories()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
