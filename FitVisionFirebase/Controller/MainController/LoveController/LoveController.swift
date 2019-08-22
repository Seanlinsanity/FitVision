//
//  LoveController.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase

class LoveController: HotController {
    
    private var loveVideos = [Video]()
    private var waitLoadingVideosTimer: Timer?
    
    var userId: String?
    var profileImageUrl: String?
    let user = UserModel()

    let noResultId = "noResultId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        collectionView?.alwaysBounceVertical = true
    }
    
    override func checkInternet() {
        if Connectivity.isConnectedToInternet{
            collectionView?.reloadData()
            activityIndicatorView.startAnimating()
        }else{
            loveVideos = [Video]()
            Alert.showBasicAlert(title: "錯誤", message: "網路服務異常，請檢查裝置的連線狀態", vc: self)
            activityIndicatorView.stopAnimating()
            collectionView?.reloadData()
        }
    }
    
    override func setupRefreshControl() {
        collectionView?.refreshControl = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.layer.masksToBounds = false
        
        fetchVideos()

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
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(handleFetchingUser), userInfo: nil, repeats: true)
            
        }
    }
    
    @objc private func handleFetchingUser() {
        guard let count = allVideos?.count else { return }
        
        if allVideos?[count - 1].channel?.profileImageUrl != nil {
            checkCurrentUser()
            timer?.invalidate()
        }
        
    }
    
    private func handleLoveReload() {
        timer?.invalidate()
        activityIndicatorView.stopAnimating()
        collectionView?.reloadData()
    }
    
    override func setupCollectionView() {
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(noResultsCell.self, forCellWithReuseIdentifier: noResultId)
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(LoveUserCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    override func setupMenuBar(){
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 2.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.3
    }
    
    override func setupNavBarButtons() {
        setupNavBarTitle(title: "   收藏影片")
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        navigationItem.rightBarButtonItems = [searchBarButtonItem]
    }
    
    @objc private func checkCurrentUser(){
        guard let uid = Auth.auth().currentUser?.uid else {
            handleLoveReload()
            let alert = UIAlertController(title: "尚未登入", message: "請先登入帳戶", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "關閉", style: .default, handler: { (_) in
                self.tabBarController?.selectedIndex = 3
            }))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if loveVideos.count == 0 || userId != uid {
            if let homeVideos = self.allVideos{
                checkUserLikeVideos(videos: homeVideos)
            }
        }
    }
    
    func checkUserLikeVideos(videos: [Video]) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        userId = uid
        
        let userRef = Database.database().reference().child("users").child(uid)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                
                self.user.email = dictionary["email"] as? String
                self.user.name = dictionary["name"] as? String
                
                self.readUserLikeVideos(videos: videos, uid: uid)
            }
        }, withCancel: nil)
        
        userRef.observe(.value, with: { (snapshot) in

            guard let dictionary = snapshot.value as? [String: Any] else { return }
            if let profileImageUrl = dictionary["profileImageUrl"] as? String{
                self.user.profileImageUrl = profileImageUrl
            }else{
                self.user.profileImageUrl = nil
            }
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            
        }, withCancel: nil)
        
    }
    
    func readUserLikeVideos(videos: [Video], uid: String){
        let likesRef = Database.database().reference().child("users-likeVideos").child(uid)
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                self.fetchUserLikeVideos(ref: likesRef, videos: videos)
            }else{
                self.loveVideos = [Video]()
                self.handleLoveReload()
            }
        }, withCancel: nil)
    }
    
    func fetchUserLikeVideos(ref: DatabaseReference, videos: [Video]){
        loveVideos = [Video]()
        ref.removeAllObservers()
        ref.observe(.childAdded, with: { (snapshot) in
            
            let videoId = snapshot.key
            
            ref.child(videoId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: Any]{
                    let secondsFrom1970 = dictionary["addLikeDate"] as? Double ?? 0
                    
                    for video in videos {
                        if video.videoId == videoId {
                            video.addLikeDate = Date(timeIntervalSince1970: secondsFrom1970)
                            self.loveVideos.append(video)
                            break
                        }
                    }
                    DispatchQueue.main.async {
                        self.loveVideos.sort(by: { (v1, v2) -> Bool in
                            return v1.addLikeDate.compare(v2.addLikeDate) == .orderedDescending
                        })
                        self.handleLoveReload()
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
        
        ref.observe(.childRemoved, with: { (snapshot) in
            
            let id = snapshot.key
            guard let index = self.loveVideos.index(where:{$0.videoId == id}) else { return }
            self.loveVideos.remove(at: index)
            
            DispatchQueue.main.async {
                self.handleLoveReload()
            }
        }, withCancel: nil)
        
    }
    
    func showAccountController(){
        tabBarController?.selectedIndex = 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! LoveUserCell
        header.user = user
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 190)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if loveVideos.count == 0 {
            return 1
        }else{
            return loveVideos.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if loveVideos.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: noResultId, for: indexPath) as! noResultsCell
            cell.titleLabel.text = "你的收藏列表中目前沒有任何影片，\n快將你喜歡的影片收藏起來吧！"
            cell.titleLabel.numberOfLines = 2
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoCell
            cell.video = loveVideos[indexPath.item]
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = loveVideos[indexPath.item]
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController
        mainTabBarController?.maximizePlayerDetails(video: video)
    }
    
}


