//
//  GuideController.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class GuideCell: BaseCell {
    
    var imageName: String? {
        didSet{
            guard let image = imageName else { return }
            guideImage.image = UIImage(named: image)
        }
    }
    
    let guideImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(guideImage)
        guideImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        guideImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        guideImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        guideImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
    }
}

class GuideController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    let guidePages = ["guide_video", "guide_category", "guide_like", "guide_workout"]
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 4
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPageIndicatorTintColor = UIColor.darkGray
        pc.pageIndicatorTintColor = .lightGray
        return pc
    }()
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
    }
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        collectionView.register(GuideCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupCollectionView()
        setupPageControl()
        
    }
    
    private func setupCollectionView(){

        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView)
        if #available(iOS 11.0, *) {
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        } else {
            collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        }
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(dismissButton)
        if #available(iOS 11.0, *) {
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        } else {
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        }
        dismissButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 16).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
    }
    
    private func setupPageControl(){
        
        view.addSubview(pageControl)
        if #available(iOS 11.0, *) {
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }else{
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        pageControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guidePages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GuideCell
        cell.imageName = guidePages[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
}

