//
//  HomeController+collectionView.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/4/20.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

extension HotController: UICollectionViewDelegateFlowLayout{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if allVideos?.count == 0{
            return 1
        }else{
            return allVideos?.count ?? 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if allVideos?.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reconnectId, for: indexPath) as! ReconnectCell
            cell.delegate = self
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoCell
            cell.video = allVideos?[indexPath.item]
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if allVideos?.count == 0 {
            return CGSize(width: view.frame.width, height: view.frame.height)
        }else{
            let height = (view.frame.width - 16 - 16) * 9 / 16
            return CGSize(width: view.frame.width, height: height + 16 + 108 + 8)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if allVideos?.count == 0 { return }
        let video = allVideos?[indexPath.item]
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController
        mainTabBarController?.maximizePlayerDetails(video: video)
    }
    
}
