//
//  MenuBar.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var homeController : HotController?
    let cellId = "cellId"
    var categories = ["難易程度", "訓練肌群", "健身教室", "更多分類"]
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.categoriesLabel.text = categories[indexPath.item]
        cell.isSelected = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleSelectCategories(indexPath: indexPath.item)
        
    }
    
    lazy var categoriesLauncher: CategoriesLauncher = {
        let launcher = CategoriesLauncher()
        launcher.menuBar = self
        return launcher
    }()
    
    func handleSelectCategories(indexPath: Int)  {
        categoriesLauncher.setupCategoryItems(indexPath: indexPath)
        
        if let navIsHidden = homeController?.navigationController?.isNavigationBarHidden {
            categoriesLauncher.showCategories(indexPath: indexPath, navIsHidden: navIsHidden)
        }
    }
    
    func showCategoryController(item : String) {
        homeController?.handleShowCategoryController(category: item)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MenuCell: BaseCell {
    
    override var isSelected: Bool{
        didSet{
            categoriesLabel.textColor = isSelected ? UIColor.rgb(red: 22, green: 171, blue: 47, alpha: 1) : .darkGray
        }
    }
    
    let categoriesLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    override func setupViews() {
        
        addSubview(categoriesLabel)
        categoriesLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        categoriesLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        categoriesLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        categoriesLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
}

