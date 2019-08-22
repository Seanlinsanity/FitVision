//
//  CategoriesLauncher.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class CategoriesLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellId"
    var categoryItems : [String]?
    var menuBar : MenuBar?
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero , collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
        
    }()
    
    var cellHeight: CGFloat = 50
    
    func setupCategoryItems(indexPath: Int) {
        
        if indexPath == 0 {
            categoryItems = ["初階", "進階", "高階"]
        }else if indexPath == 1 {
            categoryItems = ["胸肌", "背肌", "腹肌", "腿部", "臀部", "肩膀", "手臂"]
        }else if indexPath == 2 {
            categoryItems = ["飲食", "知識"]
        }else{
            categoryItems = ["女孩專區", "間歇訓練"]
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    func showCategories(indexPath: Int, navIsHidden: Bool)  {
        
        if let window = UIApplication.shared.keyWindow {
            
            let statusBarFrame = UIApplication.shared.statusBarFrame
            let statusBarFrameYOffset = statusBarFrame.height
            
            blackView.backgroundColor = UIColor(white: 0 ,alpha: 0.7)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            let height = cellHeight * CGFloat(categoryItems?.count ?? 0)
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            var y : CGFloat = 0
            
            if navIsHidden {
                if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436{
                    y = 44 + 50 + statusBarFrameYOffset - 44
                }else{
                    y = 20 + 50 + statusBarFrameYOffset - 20
                }
            }else{
                if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436{
                    y = 44 + 44 + 50 + statusBarFrameYOffset - 44
                }else{
                    y = 20 + 44 + 50 + statusBarFrameYOffset - 20
                }
            }
            
            collectionView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: 0)
            
            blackView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: window.frame.height - y)
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0 , y: y, width: self.collectionView.frame.width, height: height)
            }, completion: nil)
            
        }
    }
    
    @objc func handleDismiss(){
        
        menuBar?.collectionView.reloadData()
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            self.collectionView.frame.size.height = 0
            
        })
    }
    
    func handleSelected(item : String){
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            self.collectionView.frame.size.height = 0
            
        }){ (completed: Bool) in
            
            self.menuBar?.collectionView.reloadData()
            self.menuBar?.showCategoryController(item: item)
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        cell.categoriesLabel.text = categoryItems?[indexPath.item]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let item = categoryItems?[indexPath.item]{
            handleSelected(item : item)
        }
        
    }
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
    }
}



