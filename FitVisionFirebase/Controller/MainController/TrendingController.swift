//
//  TrendingController.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//
import UIKit
import Firebase

class TrendingController: HomeController {

    private var trendingVideos: [Video]?
    private var waitLoadingVideosTimer: Timer?
    
    override func fetchVideos() {
        waitLoadingVideosTimer?.invalidate()
        waitLoadingVideosTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(reloadHomeVideos), userInfo: nil, repeats: true)
    }
    
    override func setupRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTrendingVideos), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    @objc private func refreshTrendingVideos(){
        
        HomeApiService.sharedInstance.fetchVideos { (videos) in
            
            self.collectionView?.refreshControl?.endRefreshing()
            self.videos = videos
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.checkFetchViewsCompletion), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func reloadHomeVideos(){
        if HomeApiService.sharedInstance.isFetched{
            
            videos = HomeApiService.sharedInstance.videos
            waitLoadingVideosTimer?.invalidate()
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(checkFetchViewsCompletion), userInfo: nil, repeats: true)
            
        }
    }
    
    @objc private func checkFetchViewsCompletion() {
        
        guard let count = videos?.count else { return }
        
        if videos?[count - 1].numberOfViews != nil {
            
            trendingVideos = videos?.sorted(by: {$0.numberOfViews?.compare($1.numberOfViews ?? 0) == .orderedDescending})
            handleTrendingReload()
        }
    }
    
    
    private func handleTrendingReload(){
        if trendingVideos?[0].channel?.profileImageUrl != nil && trendingVideos?[1].channel?.profileImageUrl != nil{
            collectionView?.reloadData()
            activityIndicatorView.stopAnimating()
            timer?.invalidate()
        }
    }
    
    override func setupNavBarButtons() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  熱門影片"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        navigationItem.rightBarButtonItems = [searchBarButtonItem]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendingVideos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoCell
        cell.video = trendingVideos?[indexPath.item]

        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = trendingVideos?[indexPath.item]
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController
        mainTabBarController?.maximizePlayerDetails(video: video)
    }
}

