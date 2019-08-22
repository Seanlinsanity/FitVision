//
//  PlayerDetailsView.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/4/5.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class PlayerDetailsView: UIView, YTPlayerViewDelegate {
    
    var video: Video?{
        didSet{
            
            let indexPath = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            
            if !isFirstLoading{
                maximizeVideoView()
            }
            
            playerFrontView.video = video
            miniTitle.text = video?.title
            
            isPlaying = true
            miniPausePlayButton.setImage(UIImage(named: "pause"), for: UIControlState())

            loadYouTubeVideo()
            
            video?.fetchVideoSubtitles {
                DispatchQueue.main.async {
                    self.playerFrontView.subtitleButton.isEnabled = true
                }
            }
            
            fetchRelatedVideos()
            setupVideoInfoCellHeight()
        }
    }
    
    var relatedVideos = [Video]()
    
    var backViewHeightConstraint: NSLayoutConstraint?
    var backViewBottomConstraint: NSLayoutConstraint?
    var collectionViewTopConstraint: NSLayoutConstraint?
    var videoViewWidthConstraint: NSLayoutConstraint?
    var videoViewTopConstraint: NSLayoutConstraint?
    var videoViewleftConstraint: NSLayoutConstraint?
    var videoViewHeightConstraint: NSLayoutConstraint?
    
    var timer: Timer?
    
    var isFirstLoading = true
    var isPlaying = true
    var descriptionIsHidden = true
    var isTwoLinesTitle = true
    
    var descriptionCellHeight: CGFloat = 0
    var videoInfoHeight: CGFloat = 140
    
    let moreId = "moreCellId"
    let infoId = "videoInfoId"
    let descriptionId = "descriptionId"
    let recommendTitleId = "recommendId"
    
    lazy var tapToMaximizePlayerGesture = UITapGestureRecognizer(target: self, action: #selector(handleMiniPlayerViewTap))
    lazy var panToMinimizePlayerGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePlayerViewPanDown))
    lazy var panToMaximizePlayerGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMiniPlayerPanUp))
    
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
    
    let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
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
    
    let miniPlayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let miniPausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.addTarget(self, action: #selector(handlePausePlay), for: .touchUpInside)
        return button
        
    }()
    
    let miniDissmissButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "close")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.black
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        return button
    }()
    
    let miniTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Title here!"
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBackView()
        videoView.delegate = self
        
    }
    
    let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func fetchRelatedVideos(){
        
        relatedVideos = [Video]()
        var allVideos: [Video]? = HomeApiService.sharedInstance.videos
        
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

    private func setupBackView() {
        
        addSubview(backView)
        
        if #available(iOS 11.0, *) {
            backView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
            backView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
            backView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
            backViewHeightConstraint = backView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 9/16)
            
        } else {
            backView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            backView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            backView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            backViewHeightConstraint = backView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 9/16)
            
        }
        backViewHeightConstraint?.isActive = true
    
        backView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: backView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: backView.centerYAnchor).isActive = true
        
        setupCollectionView()
        setupVideoViews()

    }
    
    private func setupVideoViews(){
        
        backView.addSubview(videoView)
        videoView.alpha = 0
        
        videoViewTopConstraint = videoView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 0)
        videoViewTopConstraint?.isActive = true
        videoViewleftConstraint = videoView.leftAnchor.constraint(equalTo: backView.leftAnchor)
        videoViewleftConstraint?.isActive = true
        videoViewWidthConstraint = videoView.widthAnchor.constraint(equalTo: backView.widthAnchor)
        videoViewWidthConstraint?.isActive = true
        videoViewHeightConstraint = videoView.heightAnchor.constraint(equalTo: backView.heightAnchor)
        videoViewHeightConstraint?.isActive = true
        
        setupMiniPlayerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleDismiss(){
        UIApplication.mainTabBarController()?.dimissPlayerDetails()
        videoView.stopVideo()
    }
    
    
}
