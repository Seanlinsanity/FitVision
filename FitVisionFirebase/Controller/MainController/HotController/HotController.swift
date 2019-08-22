//
//  HomeController.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class HotController: UICollectionViewController, ReconnectDelegate {
    
    var allVideos: [Video]?
    var timer: Timer?
    
    let statusBarBackgroundView = UIView()
    
    let cellId = "cellId"
    let reconnectId = "reconnectId"
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.color = UIColor.darkGray
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        menuBar.categoriesLauncher.handleDismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesBarsOnSwipe = true
        
        setupActivityIndicatorView()
        setupRefreshControl()
        checkInternet()
        setupCollectionView()
        setupNavBarButtons()
        setupMenuBar()
    }
    
    func checkInternet() {
        if Connectivity.isConnectedToInternet{
            allVideos = nil
            activityIndicatorView.startAnimating()
            fetchVideos()
        }else{
             handleInternetError()
        }
    }

    func hadleReconnect() {
        if Connectivity.isConnectedToInternet{
            allVideos = nil
            activityIndicatorView.startAnimating()
            refetchVideos()
        }else{
            handleInternetError()
        }
    }
    
    private func handleInternetError(){
        allVideos = [Video]()
        Alert.showBasicAlert(title: "錯誤", message: "網路服務異常，請檢查裝置的連線狀態", vc: self)
        activityIndicatorView.stopAnimating()
        collectionView?.reloadData()
    }
    
    func fetchVideos() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(checkHomeVideo), userInfo: nil, repeats: true)
    }
    
    private func refetchVideos() {
        HomeApiService.sharedInstance.fetchVideos { (videos) in
            self.allVideos = videos
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.checkNumberOfViewsCompletion), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func checkHomeVideo(){
        
        if HomeApiService.sharedInstance.isFetched {
            timer?.invalidate()
            
            allVideos = HomeApiService.sharedInstance.videos
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(checkNumberOfViewsCompletion), userInfo: nil, repeats: true)
        }
    }
    
    @objc func checkNumberOfViewsCompletion() {
        
        guard let count = allVideos?.count else { return }
        if allVideos?[count - 1].publishedAt != nil {
            allVideos = allVideos?.sorted(by: {$0.publishedAt?.compare($1.publishedAt ?? 0) == .orderedDescending})
            handleHomeReload()
        }
    }
    
    private func handleHomeReload(){
        
        if allVideos?[0].channel?.profileImageUrl != nil && allVideos?[1].channel?.profileImageUrl != nil{
            timer?.invalidate()
            collectionView?.reloadData()
            collectionView?.refreshControl?.endRefreshing()
            activityIndicatorView.stopAnimating()
            print(allVideos?.count)
        }
    }
    
    func setupActivityIndicatorView(){
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setupRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    @objc private func handleRefresh(){
        refetchVideos()
    }
    
    lazy var menuBar : MenuBar = {
        let menu = MenuBar()
        menu.translatesAutoresizingMaskIntoConstraints = false
        menu.layer.shadowColor = UIColor.black.cgColor
        menu.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        menu.layer.shadowRadius = 2.0
        menu.layer.shadowOpacity = 0.3
        menu.layer.masksToBounds = false
        menu.homeController = self
        return menu
    }()
    
    func setupMenuBar(){
        
        let greenBackView : UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor.rgb(red: 22, green: 171, blue: 47, alpha: 1)
            return view
        }()
        
        view.addSubview(greenBackView)
        view.addSubview(menuBar)
        
        greenBackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        greenBackView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        greenBackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        greenBackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        if #available(iOS 11.0, *) {
            menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        }
        menuBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menuBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
    }
    
    func setupCollectionView() {
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(ReconnectCell.self, forCellWithReuseIdentifier: reconnectId)
    }
    
    func setupNavBarButtons(){
        setupNavBarTitle(title: "   發燒影片")
        navigationItem.title = ""
        
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        navigationItem.rightBarButtonItems = [searchBarButtonItem]
        
    }
    
    @objc func handleSearch() {
        let searchController = SearchController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.pushViewController(searchController, animated: true)
    }
    
    func handleShowCategoryController(category : String){
        showCategoryController(category: category)
    }

    func handleShowChannelController(channel: String){
        showChannelController(channel: channel)
    }

}


