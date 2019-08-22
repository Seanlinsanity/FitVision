//
//  SelectVideoController.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/4/9.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

protocol SelectVideoDelegate {
    func selectVideo(video: Video)
}

class SelectVideoController: SearchController {
    
    var delegate: SelectVideoDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.layer.masksToBounds = false

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func reloadHomeVideos() {
        if HomeApiService.sharedInstance.isFetched{
            
            allVideos = HomeApiService.sharedInstance.videos
            searchVideos = allVideos?.sorted(by: {$0.publishedAt?.compare($1.publishedAt ?? 0) == .orderedDescending})
            waitLoadingVideosTimer?.invalidate()
            collectionView?.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = searchVideos?[indexPath.item] ?? Video()
        delegate?.selectVideo(video: video)
        
        _ = navigationController?.popViewController(animated: true)

    }
    
    
}
