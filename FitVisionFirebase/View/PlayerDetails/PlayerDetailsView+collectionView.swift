//
//  PlayerDetailsView+collectionView.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/4/20.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

extension PlayerDetailsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func setupCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MoreVideoCell.self, forCellWithReuseIdentifier: moreId)
        collectionView.register(VideoInfoCell.self, forCellWithReuseIdentifier: infoId)
        collectionView.register(VideoDescriptionCell.self, forCellWithReuseIdentifier: descriptionId)
        collectionView.register(RecommendVideoTitleCell.self, forCellWithReuseIdentifier: recommendTitleId)
        
        addSubview(collectionView)
        collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 0)
        collectionViewTopConstraint?.isActive = true
        collectionView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
        collectionView.showsVerticalScrollIndicator = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedVideos.count + 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoId, for: indexPath) as! VideoInfoCell
            cell.isTwoLinesTitle = isTwoLinesTitle
            cell.playerDetailsView = self
            cell.video = video
            return cell
            
        }else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionId, for: indexPath) as! VideoDescriptionCell
            cell.videoDescription = video?.videoDescription
            return cell
            
        }else if indexPath.item == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recommendTitleId, for: indexPath) as! RecommendVideoTitleCell
            return cell
            
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: moreId, for: indexPath) as! MoreVideoCell
            if relatedVideos.count > 0 {
                cell.video = relatedVideos[indexPath.item - 3]
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0 {
            return CGSize(width: collectionView.frame.width, height: videoInfoHeight)
        }else if indexPath.item == 1{
            return CGSize(width: collectionView.frame.width, height: descriptionCellHeight)
        }else if indexPath.item == 2{
            return CGSize(width: collectionView.frame.width, height: 60)
        }else{
            return CGSize(width: collectionView.frame.width, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item > 2{
            let video = relatedVideos[indexPath.item - 3]
            let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController
            mainTabBarController?.maximizePlayerDetails(video: video)
        }
    }
    
    func setupVideoInfoCellHeight(){
        
        if let title = video?.title {
            let size = CGSize(width: frame.width - 48, height: 1000) //height is a large abitrary
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)], context: nil)
            
            if estimatedRect.size.height > 40 {
                videoInfoHeight = 206
                isTwoLinesTitle = true
            }else{
                videoInfoHeight = 176
                isTwoLinesTitle = false
            }
        }
    }
    
    func showDescription(descriptionIsHidden: Bool) {
        
        if let description = video?.videoDescription {
            let size = CGSize(width: frame.width - 32, height: 100000) //height is a large abitrary
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedRect = NSString(string: description).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], context: nil)
            
            if !descriptionIsHidden {
                descriptionCellHeight = estimatedRect.height + 72
            }else{
                descriptionCellHeight = 0
            }
        }
        
        let indexPath = IndexPath(item: 1, section: 0)
        collectionView.reloadItems(at: [indexPath])
    }
    
}
