//
//  Extension_UICollectionViewController.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/5/14.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

extension UICollectionViewController{
    
    func showChannelController(channel: String){
        let categoryChannelController = CategoryChannelController(collectionViewLayout: UICollectionViewFlowLayout())
        categoryChannelController.navigationItem.title = channel
        categoryChannelController.categoryTitle = channel
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController(categoryChannelController, animated: true)
    }
    
    func showCategoryController(category : String){
        let categoryController = CategoryController(collectionViewLayout: UICollectionViewFlowLayout())
        categoryController.navigationItem.title = category
        categoryController.categoryTitle = category
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController(categoryController, animated: true)
        
    }
    
}
