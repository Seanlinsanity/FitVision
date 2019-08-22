//
//  CustomTabBarController.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//
import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let index = viewControllers?.index(of: viewController) else { return false }

        if selectedViewController == nil{ return false }

        if viewController == selectedViewController {
            if index == 0 || index == 1{
                scrollToTop(index: index)
            }
            return true
        }
        return true
    }
    
    private func scrollToTop(index: Int){
        if !HomeApiService.sharedInstance.isFetched { return }
        
        let navVC = viewControllers?[index] as? UINavigationController
        let collectionVC = navVC?.viewControllers.first as? UICollectionViewController
        
        if index == 0 {
            guard let topContentInset = collectionVC?.collectionView?.contentInset.top else { return }
            if let attributes = collectionVC?.collectionView?.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: 0)) {
                collectionVC?.collectionView?.setContentOffset(CGPoint(x: 0, y: attributes.frame.origin.y - topContentInset), animated: true)
                collectionVC?.navigationController?.isNavigationBarHidden = false
            }
        }else{
            let indexPath = IndexPath(item: 0, section: 0)
            collectionVC?.collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    let playerDetailsView = PlayerDetailsView()
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!

    fileprivate func setupPlayerDetailView(){
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 2 * view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        
        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        bottomAnchorConstraint = playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        tabBar.tintColor = UIColor.mainGreen
        tabBar.isTranslucent = false
        
        setupPlayerDetailView()
        setupTabBarBorder()
        
        let homeVC = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
        let homeNavController = createNavController(vc: homeVC, title: "首頁", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home_s"))
        
        let hotVC = HotController(collectionViewLayout: UICollectionViewFlowLayout())
        let hotNavController = createNavController(vc: hotVC, title: "發燒", image: UIImage(named: "hot"), selectedImage: UIImage(named: "hot_s"))
        
        let loveVC = LoveController(collectionViewLayout: UICollectionViewFlowLayout())
        let loveNavController = createNavController(vc: loveVC, title: "收藏", image: UIImage(named: "heart"), selectedImage: #imageLiteral(resourceName: "heart_s"))
        
        let accountVC = AccountController()
        let accountNavController = createNavController(vc: accountVC, title: "帳戶", image: UIImage(named: "profile"), selectedImage: #imageLiteral(resourceName: "profile_s"))
        
        let settingVC = SettingController(collectionViewLayout: UICollectionViewFlowLayout())
        let settingNavController = createNavController(vc: settingVC, title: "更多", image: UIImage(named: "menu"), selectedImage: #imageLiteral(resourceName: "menu_s"))
        
        viewControllers = [homeNavController, hotNavController, loveNavController, accountNavController, settingNavController]
        
    }
    
    private func createNavController(vc: UIViewController,title: String, image: UIImage?, selectedImage: UIImage?) -> UINavigationController{
     
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image?.withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
        return navController
    }
    
    private func setupTabBarBorder(){
        let topBorder = CALayer()
        tabBar.layer.addSublayer(topBorder)
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 1)
        topBorder.backgroundColor = UIColor.rgb(red: 229, green: 231, blue: 235, alpha: 1).cgColor
        tabBar.clipsToBounds = true
    }
}

