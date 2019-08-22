//
//  CateogoryChannelController.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/3/29.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class CategoryChannelController: HotController{
    
    private var categoryVideos: [Video]?
    private var waitLoadingVideosTimer: Timer?
    var categoryTitle: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = categoryTitle
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    override func fetchVideos() {
        waitLoadingVideosTimer?.invalidate()
        waitLoadingVideosTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(reloadHomeVideos), userInfo: nil, repeats: true)
    }
    
    @objc private func reloadHomeVideos(){
        if HomeApiService.sharedInstance.isFetched{
            
            allVideos = HomeApiService.sharedInstance.videos
            waitLoadingVideosTimer?.invalidate()
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(checkFetchCategoriesCompletion), userInfo: nil, repeats: true)
            
        }
    }
    
    override func setupRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCategoryVideos), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    @objc private func refreshCategoryVideos(){
        HomeApiService.sharedInstance.fetchVideos { (videos) in
            
            self.collectionView?.refreshControl?.endRefreshing()
            self.allVideos = videos
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.checkFetchCategoriesCompletion), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func checkFetchCategoriesCompletion(){
        guard let categoryTag = categoryTitle else { return }
        guard let count = allVideos?.count else { return }
        if allVideos?[count - 1].channel?.name == nil { return }
        
        categoryVideos = allVideos?.filter({return $0.channel?.name == categoryTag})
        categoryVideos = categoryVideos?.sorted(by: {$0.publishedAt?.compare($1.publishedAt ?? 0) == .orderedDescending})
            
        reloadChannelVideos()
    }
    
    private func reloadChannelVideos(){
                
        if categoryVideos?[0].channel?.profileImageUrl != nil{
            collectionView?.reloadData()
            activityIndicatorView.stopAnimating()
            timer?.invalidate()
        }
    }
    
    override func setupNavBarButtons() {
                
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        navigationItem.rightBarButtonItems = [searchBarButtonItem]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryVideos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoCell
        cell.video = categoryVideos?[indexPath.item]
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = categoryVideos?[indexPath.item]
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController
        mainTabBarController?.maximizePlayerDetails(video: video)
        
    }
    
}
