//
//  VideoPlayer.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import Firebase


class VideoPlayerController: UIViewController, YTPlayerViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,UICollectionViewDataSource, PlayerFrontViewDelegate {
    
    weak var video: Video?
    weak var timer: Timer?
    weak var moreYtVideo: Video?
    var allVideos : [Video]?
    var relatedVideos = [Video]()
    var toStop = false
    var isPlaying = false
    
    let moreId = "moreCellId"
    let infoId = "videoInfoId"
    let descriptionId = "descriptionId"
    let recommendTitleId = "recommendId"
    
    var descriptionIsHidden = true
    var isTwoLinesTitle = true
    var descriptionCellHeight: CGFloat = 0
    var videoInfoHeight: CGFloat = 140
    var collectionViewTopConstraint: NSLayoutConstraint?
    var backViewHeightConstraint: NSLayoutConstraint?
    var backViewBottomConstraint: NSLayoutConstraint?
    var currentTime: Float?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        
        AppUtility.lockOrientation(.allButUpsideDown)
        tabBarController?.tabBar.isTranslucent = true
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.reloadItems(at: [indexPath])
        
        guard let currentTime = currentTime else { return }
        videoView.cueVideo(byId: video!.videoId!, startSeconds: currentTime, suggestedQuality: .medium)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppUtility.lockOrientation(.portrait)
        tabBarController?.tabBar.isTranslucent = false
        
        toStop = true
        isPlaying = false
        currentTime = videoView.currentTime()
        
        videoView.stopVideo()
        playerFrontView.pausePlayButton.setImage(UIImage(named: "play"), for: UIControlState())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationBar is always not hidden!
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = UIColor.white

        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        navigationItem.rightBarButtonItems = [searchBarButtonItem]
        
        view.backgroundColor = .black
        
        videoView.delegate = self
        setupVideoView()
        fetchRelatedVideos()
        
    }
    
    private func fetchRelatedVideos(){
        
        allVideos = HomeApiService.sharedInstance.videos
        
        guard let relatedVideosId = video?.relatedVideosId else { return }
        for id in relatedVideosId {
            let index = allVideos?.index(where: { (video) -> Bool in
                video.videoId == id
            })
            if let indexInAllVideos = index {
                if let relatedVideo = allVideos?[indexInAllVideos]{
                    relatedVideos.append(relatedVideo)
                }
            }
        }
        collectionView.reloadData()
    }
    
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let videoView : YTPlayerView = {
        
        let video = YTPlayerView()
        video.backgroundColor = .black
        video.translatesAutoresizingMaskIntoConstraints = false
        return video
        
    }()
    
    lazy var playerFrontView : PlayerFrontView = {
        
        let view = PlayerFrontView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.delegate = self
        return view
        
    }()
    
    let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    @objc func handleSearch() {
        let searchController = SearchController(collectionViewLayout: UICollectionViewFlowLayout())

        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.pushViewController(searchController, animated: true)
    }
    
    fileprivate func handleCurrentLabelChange(currentTime: Float) {
        
        let secsString = String(format: "%02d", Int(Int(currentTime) % 60))
        
        if video?.hour != nil {
            
            if Int(currentTime) / 60 >= 60 {
                
                let minsString = String(format: "%02d", Int(Int(currentTime) % 3600 / 60))
                let hoursString = String(format: "%02d", Int(Int(currentTime) / 3600))
                playerFrontView.currentTimeLabel.text = "\(hoursString):\(minsString):\(secsString)"
                
                
            }else{
                let hoursString = "00"
                let minsString = String(format: "%02d", Int(Int(currentTime) / 60))
                playerFrontView.currentTimeLabel.text = "\(hoursString):\(minsString):\(secsString)"
                
            }
            
        }else{
            
            let minsString = String(format: "%02d", Int(Int(currentTime) / 60))
            playerFrontView.currentTimeLabel.text = "\(minsString):\(secsString)"
            
            
        }
    }
    
    func handleSliderChange() {
        
        let min = video?.min ?? "0"
        let sec = video?.sec ?? "0"
        let hour = video?.hour ?? "0"
                
        let totalSec = Float(hour)! * 3600 + Float(min)! * 60 + Float(sec)!
        let currentTime = playerFrontView.videoSlider.value * totalSec
        videoView.seek(toSeconds: currentTime, allowSeekAhead: true)
        
        handleCurrentLabelChange(currentTime: currentTime)
        
        video?.time = currentTime
        video?.setupSubtitles()
        setupSubtitleLabel()
    }
    
    func handlePausePlay() {
        
        if isPlaying {
            videoView.pauseVideo()
            playerFrontView.pausePlayButton.setImage(UIImage(named: "play"), for: UIControlState())
            
        }else {
            videoView.playVideo()
            playerFrontView.pausePlayButton.setImage(UIImage(named: "pause"), for: UIControlState())
        }
        isPlaying = !isPlaying
    }
    
    func setupVideoView() {
        
        view.addSubview(backView)
        
        if #available(iOS 11.0, *) {
            backView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            backView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            backView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            backViewHeightConstraint = backView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 9/16)

        } else {
            backView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            backView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            backView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            backViewHeightConstraint = backView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/16)

        }
        backViewHeightConstraint?.isActive = true
        
        backView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: backView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: backView.centerYAnchor).isActive = true
        
        setupCollectionView()
        loadYouTubeVideo()
    }
    
    private func loadYouTubeVideo(){
        if let videoId = video?.videoId {
            videoView.load(withVideoId: videoId, playerVars: ["playsinline": 1, "showinfo": 0, "modestbranding": 0, "controls": 0, "rel": 0, "iv_load_policy": 3, "hl": "zu"])
            print(videoId)
        }
        
    }
    
    // if appropriate, make sure to stop your timer in `deinit`
    deinit {
        print("videoPlayer is being deinitialized")
        stopTimer()
    }
    
    func setupCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MoreVideoCell.self, forCellWithReuseIdentifier: moreId)
        collectionView.register(VideoInfoCell.self, forCellWithReuseIdentifier: infoId)
        collectionView.register(VideoDescriptionCell.self, forCellWithReuseIdentifier: descriptionId)
        collectionView.register(RecommendVideoTitleCell.self, forCellWithReuseIdentifier: recommendTitleId)
        
        setupVideoInfoCellHeight()
        view.addSubview(collectionView)
        
        collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.width * 9 / 16)
        collectionViewTopConstraint?.isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
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
//            cell.videoPlayer = self
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
            moreYtVideo = relatedVideos[indexPath.item - 3]
            showMoreVideo()
        }
    }
    
    private func showMoreVideo() {
        
        let playVideoViewController = VideoPlayerController()
        playVideoViewController.video = moreYtVideo
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.pushViewController(playVideoViewController, animated: true)
        
    }
    
    private func setupVideoInfoCellHeight(){
        
        if let title = video?.title {
            let size = CGSize(width: view.frame.width - 90, height: 1000) //height is a large abitrary
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)], context: nil)

            if estimatedRect.size.height > 40 {
                videoInfoHeight = 140
                isTwoLinesTitle = true
            }else{
                videoInfoHeight = 110
                isTwoLinesTitle = false
            }
        }
    }
    
    func showTagController(title: String){
        let categoryController = CategoryController(collectionViewLayout: UICollectionViewFlowLayout())
        categoryController.navigationItem.title = title
        categoryController.categoryTitle = title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.pushViewController(categoryController, animated: true)
    }
    
    func showChannelController(channel: String){
        let categoryChannelController = CategoryChannelController(collectionViewLayout: UICollectionViewFlowLayout())
        categoryChannelController.navigationItem.title = channel
        categoryChannelController.categoryTitle = channel
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.pushViewController(categoryChannelController, animated: true)
    }
    
}
