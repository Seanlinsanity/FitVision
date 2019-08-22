//
//  FeaturedHeaderView.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/5/1.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class HomeHeaderView: UICollectionReusableView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var currentPage = 0
    var timer: Timer?
    var recommendedVideos: [Video]?
    var videos: [Video]?
    var slideAnimationTimer: Timer?

    let cellId = "cellId"
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(red: 200, green: 200, blue: 200, alpha: 1)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    let shimmerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let maskGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.3, 0.7, 1]
        return gradientLayer
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 0
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPageIndicatorTintColor = UIColor.darkGray
        pc.pageIndicatorTintColor = .lightGray
        return pc
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeHeaderCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        setupShimmerAnimation()
        
        addSubview(pageControl)
        pageControl.heightAnchor.constraint(equalToConstant: 16).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        pageControl.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        pageControl.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(checkHomeVideos), userInfo: nil, repeats: true)
    }
    
    fileprivate func setupShimmerAnimation(){
        addSubview(backView)
        backView.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 0).isActive = true
        backView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        backView.leftAnchor.constraint(equalTo: collectionView.leftAnchor, constant: 8).isActive = true
        backView.rightAnchor.constraint(equalTo: collectionView.rightAnchor, constant: -8).isActive = true
        
        backView.addSubview(shimmerView)
        shimmerView.topAnchor.constraint(equalTo: backView.topAnchor).isActive = true
        shimmerView.bottomAnchor.constraint(equalTo: backView.bottomAnchor).isActive = true
        shimmerView.leftAnchor.constraint(equalTo: backView.leftAnchor).isActive = true
        shimmerView.rightAnchor.constraint(equalTo: backView.rightAnchor).isActive = true
        
        layoutIfNeeded()
        shimmerView.layer.mask = maskGradientLayer
        maskGradientLayer.frame = shimmerView.frame
        maskGradientLayer.frame.size = CGSize(width: frame.width * 1.5, height: frame.width)
        
        let angle = -75 * CGFloat.pi / 180
        maskGradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -frame.width
        animation.toValue = 0.5 * frame.width
        animation.repeatCount = Float.infinity
        animation.duration = 2
        
        maskGradientLayer.add(animation, forKey: "animationKey")
    }
    
    @objc private func checkHomeVideos(){
        if HomeApiService.sharedInstance.isFetched {
            timer?.invalidate()
            videos = HomeApiService.sharedInstance.videos
            FeatureService.shared.fetchRecomendVideos(completion: fetchRecommendedVideosFromService)
        }
    }

    private func fetchRecommendedVideosFromService(videos: [Video]) -> (){
        recommendedVideos = []
        recommendedVideos = videos
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.backView.removeFromSuperview()
            self.pageControl.numberOfPages = self.recommendedVideos?.count ?? 0
            self.slideAnimationTimer?.invalidate()
            self.slideAnimationTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.headerViewSlideAnimation), userInfo: nil, repeats: true)
        }
    }
    
    @objc func headerViewSlideAnimation(){
        
        if recommendedVideos?[0].thumbnailImageUrl == nil { return }
        guard let numOfRecommendedVideos = recommendedVideos?.count else { return }
        
        if currentPage == numOfRecommendedVideos - 1{
            currentPage = 0
        }else{
            currentPage += 1
        }
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentPage
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        slideAnimationTimer?.invalidate()
        let x = targetContentOffset.pointee.x
        currentPage = Int(x / frame.width)
        pageControl.currentPage = currentPage
        slideAnimationTimer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(headerViewSlideAnimation), userInfo: nil, repeats: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedVideos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeHeaderCell
        cell.video = recommendedVideos?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = recommendedVideos?[indexPath.item]
        UIApplication.mainTabBarController()?.maximizePlayerDetails(video: video)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
