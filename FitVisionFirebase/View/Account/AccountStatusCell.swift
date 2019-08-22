//
//  AccountStatusCell.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class AccountStatusCell: BaseCell {
    
    let statusTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "近期觀看資訊"
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playStatusImage : UIImageView = {
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "views")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = UIColor.rgb(red: 22, green: 171, blue: 47, alpha: 1)
        return image
    }()
    
    let playLabel : UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = " 本月觀看影片"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberOfPlay : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 80)
        label.textAlignment = .right
        return label
    }()
    
    let unitOfPlay : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = "部"
        return label
    }()
    
    let likeStatusImage : UIImageView = {
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "love")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = UIColor.rgb(red: 22, green: 171, blue: 47, alpha: 1)
        return image
    }()
    
    let likeLabel : UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = "收藏影片總數"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberOfLike : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 80)
        label.textAlignment = .right
        return label
    }()
    
    let unitOfLike : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = "部"
        return label
    }()
    
    let upSeperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    let bottomSeperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        
        addSubview(statusTitle)
        addSubview(playStatusImage)
        addSubview(playLabel)
        addSubview(numberOfPlay)
        addSubview(unitOfPlay)
        addSubview(upSeperatorView)
        addSubview(likeStatusImage)
        addSubview(likeLabel)
        addSubview(numberOfLike)
        addSubview(unitOfLike)
        addSubview(bottomSeperatorView)
        
        statusTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        statusTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40).isActive = true
        statusTitle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        statusTitle.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        playStatusImage.topAnchor.constraint(equalTo: statusTitle.bottomAnchor, constant: 16).isActive = true
        playStatusImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40).isActive = true
        playStatusImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        playStatusImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        playLabel.topAnchor.constraint(equalTo: playStatusImage.topAnchor).isActive = true
        playLabel.leftAnchor.constraint(equalTo: playStatusImage.rightAnchor, constant: 16).isActive = true
        playLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 16).isActive = true
        playLabel.heightAnchor.constraint(equalTo: playStatusImage.heightAnchor).isActive = true
        
        numberOfPlay.topAnchor.constraint(equalTo: playStatusImage.bottomAnchor, constant: 8).isActive = true
        numberOfPlay.leftAnchor.constraint(equalTo: playStatusImage.rightAnchor, constant: -24).isActive = true
        numberOfPlay.widthAnchor.constraint(equalToConstant: 160).isActive = true
        numberOfPlay.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        unitOfPlay.bottomAnchor.constraint(equalTo: numberOfPlay.bottomAnchor).isActive = true
        unitOfPlay.leftAnchor.constraint(equalTo: numberOfPlay.rightAnchor, constant: 16).isActive = true
        unitOfPlay.widthAnchor.constraint(equalToConstant: 58).isActive = true
        unitOfPlay.heightAnchor.constraint(equalToConstant: 58).isActive = true
        
        upSeperatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 256).isActive = true
        upSeperatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        upSeperatorView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        upSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        likeStatusImage.topAnchor.constraint(equalTo: upSeperatorView.bottomAnchor, constant: 32).isActive = true
        likeStatusImage.leftAnchor.constraint(equalTo: playStatusImage.leftAnchor).isActive = true
        likeStatusImage.widthAnchor.constraint(equalTo: playStatusImage.widthAnchor).isActive = true
        likeStatusImage.heightAnchor.constraint(equalTo: playStatusImage.heightAnchor).isActive = true
        likeLabel.topAnchor.constraint(equalTo: likeStatusImage.topAnchor).isActive = true
        likeLabel.leftAnchor.constraint(equalTo: likeStatusImage.rightAnchor, constant: 16).isActive = true
        likeLabel.rightAnchor.constraint(equalTo: playLabel.rightAnchor).isActive = true
        likeLabel.heightAnchor.constraint(equalTo: likeStatusImage.heightAnchor).isActive = true
        
        numberOfLike.topAnchor.constraint(equalTo: likeStatusImage.bottomAnchor, constant: 8).isActive = true
        numberOfLike.leftAnchor.constraint(equalTo: numberOfPlay.leftAnchor).isActive = true
        numberOfLike.widthAnchor.constraint(equalTo: numberOfPlay.widthAnchor).isActive = true
        numberOfLike.heightAnchor.constraint(equalTo: numberOfPlay.heightAnchor).isActive = true
        
        unitOfLike.bottomAnchor.constraint(equalTo: numberOfLike.bottomAnchor).isActive = true
        unitOfLike.leftAnchor.constraint(equalTo: numberOfLike.rightAnchor, constant: 16).isActive = true
        unitOfLike.widthAnchor.constraint(equalTo: unitOfPlay.widthAnchor).isActive = true
        unitOfLike.heightAnchor.constraint(equalTo: unitOfPlay.heightAnchor).isActive = true
        
        bottomSeperatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomSeperatorView.leftAnchor.constraint(equalTo: upSeperatorView.leftAnchor).isActive = true
        bottomSeperatorView.rightAnchor.constraint(equalTo: upSeperatorView.rightAnchor).isActive = true
        bottomSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}

