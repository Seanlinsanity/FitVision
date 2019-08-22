//
//  FeaturedCell.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/5/1.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

protocol MoreVideosForCategoryDelegate {
    func handleMoreCategoryVideos(category: String)
}

class HomeCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var category: String?{
        didSet{
            categoryNameLabel.text = category
        }
    }
    var delegate: MoreVideosForCategoryDelegate?
    var videos: [Video]?{
        didSet{
            DispatchQueue.main.async {
                self.videosCollectionView.reloadData()
            }
        }
    }
    
    let cellId = "cellId"
    
    let videosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let categoryNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "精選類別"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        return lb
    }()
    
    lazy var moreButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .mainGreen
        btn.setTitle("更多", for: .normal)
        btn.addTarget(self, action: #selector(handleMoreCategoryVideos), for: .touchUpInside)
        return btn
    }()
    
    @objc private func handleMoreCategoryVideos(){
        guard let category = category else { return }
        delegate?.handleMoreCategoryVideos(category: category)
    }
    
    let seperatorLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        videosCollectionView.showsHorizontalScrollIndicator = false
    }
    
    func setupViews(){
        videosCollectionView.register(HomeVideoCell.self, forCellWithReuseIdentifier: cellId)
        videosCollectionView.dataSource = self
        videosCollectionView.delegate = self
        
        addSubview(categoryNameLabel)
        categoryNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
        categoryNameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        categoryNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 60).isActive = true
        categoryNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(moreButton)
        moreButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        moreButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        moreButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(videosCollectionView)
        videosCollectionView.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: 8).isActive = true
        videosCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        videosCollectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        videosCollectionView.heightAnchor.constraint(equalTo: heightAnchor, constant: -30).isActive = true
        
        addSubview(seperatorLineView)
        seperatorLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14).isActive = true
        seperatorLineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        seperatorLineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = videos?.count else { return 0 }
        return count > 5 ? 5 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeVideoCell
        cell.video = videos?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: frame.height - 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = videos?[indexPath.item]
        UIApplication.mainTabBarController()?.maximizePlayerDetails(video: video)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

