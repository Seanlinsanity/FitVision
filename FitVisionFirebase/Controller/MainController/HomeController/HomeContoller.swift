//
//  FeaturedContoller.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/5/1.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, MoreVideosForCategoryDelegate, FooterMoreCategoriesDelegate {

    let cellId = "cellId"
    let headerId = "headerId"
    let footerId = "footerId"
    let categories = ["胸肌", "腹肌", "臀部", "手臂", "飲食", "女孩專區"]
    var allVideos: [Video]?
    var allCateogoryVideos = [[Video]]()
    var waitHomeVideosLoadTimer: Timer?
    var waitImageLoadtimer: Timer?
    var waitChannelLoadtimer: Timer?
    var notificationTimer: Timer?

    var logoImageView: UIImageView?
    var titleLabel: UILabel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLabel?.text = "FitVision"
        logoImageView?.image = #imageLiteral(resourceName: "logo_clear")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        titleLabel?.text = ""
        logoImageView?.image = UIImage()
    }
    
    fileprivate func setupBaseVideos() {
        let videos = [
            Video(),
            Video(),
            Video(),
            Video(),
            Video()
        ]
        allCateogoryVideos = [
            videos,
            videos,
            videos,
        ]
    }
    
    func checkInternet() {
        if Connectivity.isConnectedToInternet{
            fetchVideos()
        }else{
            Alert.showBasicAlert(title: "錯誤", message: "網路服務異常，請檢查裝置的連線狀態", vc: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.hidesBarsOnSwipe = true
        
        setupBaseVideos()
        setupNavBar()
        setupCollectionView()
        checkInternet()
        setupRefreshControl()
        
        MyPurchaseProducts.store.requestProducts()
 
    }
    
    private func setupRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchVideos), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    @objc private func fetchVideos(){
        HomeApiService.sharedInstance.fetchVideos { (videos) in
            self.allVideos = videos
            self.waitHomeVideosLoadTimer?.invalidate()
            self.waitHomeVideosLoadTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.checkFetchCategoryCompletion), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func checkFetchCategoryCompletion(){
        
        guard let count = allVideos?.count else { return }
        guard let lastVideocategories = allVideos?[count - 1].categories.count else { return }
        guard let _ = allVideos?[count - 1].numberOfViews else { return }
        
        if lastVideocategories > 0 {
            waitHomeVideosLoadTimer?.invalidate()
            allCateogoryVideos = []
            categories.forEach { (category) in
                let categoryVideos = allVideos?.filter({$0.categories.contains(category)})
                let hotCategoryVideos = categoryVideos?.sorted(by: {$0.publishedAt?.compare($1.publishedAt ?? 0) == .orderedDescending})
                allCateogoryVideos.append(hotCategoryVideos ?? [])
            }
            
            handleReload()
            
            waitImageLoadtimer?.invalidate()
            waitImageLoadtimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(checkImageLoadCompletion), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc private func checkImageLoadCompletion(){
        
        for i in 0...1{
            for j in 0...2{
                if allCateogoryVideos[i][j].thumbnailImageUrl == nil { return }
            }
        }
        
        waitImageLoadtimer?.invalidate()
        handleReload()
    
        waitChannelLoadtimer?.invalidate()
        waitChannelLoadtimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(checkChannelLoadCompletion), userInfo: nil, repeats: true)
    }
    
    @objc private func checkChannelLoadCompletion(){
        for i in 0...1 {
            for j in 0...2{
               if allCateogoryVideos[i][j].channel?.name == nil { return }
            }
        }
        waitChannelLoadtimer?.invalidate()
        handleReload()
    }

    private func handleReload(){
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            self.collectionView?.refreshControl?.endRefreshing()
        }
    }
    
    private func setupCollectionView(){
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        collectionView?.backgroundColor = .white
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(HomeHeaderView.self, forSupplementaryViewOfKind:  UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(HomeFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
    }
    
    private func setupNavBar(){
        let navigationBarTuple = setupNavBarLogo()
        titleLabel = navigationBarTuple.0
        logoImageView = navigationBarTuple.1
        
        navigationItem.title = ""
        
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        navigationItem.rightBarButtonItems = [searchBarButtonItem]
    }
    
    @objc private func handleSearch() {
        let searchController = SearchController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.pushViewController(searchController, animated: true)
    }
    
    func handleMoreCategoryVideos(category: String) {
        showCategoryController(category: category)
    }
    
    func handleShowChannelController(channel: String){
        showChannelController(channel: channel)
    }
    
    func handleMoreCategories() {
        let allCategoriesController = AllCategoriesController()
        allCategoriesController.homeController = self
        let navController = UINavigationController(rootViewController: allCategoriesController)
        allCategoriesController.navigationItem.title = "更多分類"
        present(navController, animated: true, completion: nil)
    }
    
    
}
