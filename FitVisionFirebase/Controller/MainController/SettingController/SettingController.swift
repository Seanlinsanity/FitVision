//
//  SettingController.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class Setting: NSObject{
    
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

enum SettingName: String{
    case guide = "使用說明"
    case facebook = "粉絲專頁"
    case rate = "評分"
    case feedback = "問題與意見回饋"
    case version = "版本"
}


class SettingController: UICollectionViewController, UICollectionViewDelegateFlowLayout, FeedbackDelegate {
    
    let cellId = "cellId"
    let titleId = "titleId"
    let cellHeight: CGFloat = 60
    
    let settings : [Setting] = {
        return [Setting(name: .guide,  imageName: "guide"),Setting(name: .facebook, imageName: "facebook"),Setting(name: .rate, imageName: "rate"), Setting(name: .feedback, imageName: "feedback"), Setting(name: .version, imageName: "version")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 2.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.3
        navigationController?.navigationBar.layer.masksToBounds = false

        setupNavBarTitle(title: "  更多資訊")
        
        collectionView?.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(TitleCell.self, forCellWithReuseIdentifier: titleId)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: titleId, for: indexPath) as! TitleCell
            setTitleCell(cell: cell)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
            cell.setting = settings[indexPath.item - 1]
            setupVersion(index: indexPath.item, cell: cell)
            
            return cell
        }
    }
    
    private func setupVersion(index: Int, cell: SettingCell){
        if index == 5 {
            cell.noteLabel.text = HomeApiService.sharedInstance.version
        }
    }
    
    
    private func setTitleCell(cell: TitleCell){
        cell.nameLabelleftAnchorConstraint?.constant = 16
        cell.nameLabel.font = UIFont.systemFont(ofSize: 16)
        cell.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        cell.nameLabel.text = "App支援"
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 || indexPath.item == 5{ return }
        
        let setting = settings[indexPath.item - 1]
        showSettingDetailVC(setting: setting)
        
    }
    
    lazy var feedbackLauncher: FeedbackLauncher = {
        let laucher = FeedbackLauncher()
        laucher.delegate = self
        return laucher
    }()
    
    
    func showSettingDetailVC(setting: Setting){
        
        if setting.name == SettingName.feedback{
            
            feedbackLauncher.setupFeedback()
            
        }else if setting.name == SettingName.facebook{
            
            guard let fbAppURL = URL(string:"fb://profile/157878248149579") else { return }
            guard let fbURL = URL(string:"https://www.facebook.com/fitvisiontw/") else { return }

            if #available(iOS 10.0, *){
                if UIApplication.shared.canOpenURL(fbAppURL) {
                    UIApplication.shared.open(fbAppURL)
                } else {
                    UIApplication.shared.open(fbURL)
                }
            }

            
        }else if setting.name == SettingName.guide{
            
            let guideController = GuideController()
            guideController.navigationItem.title = setting.name.rawValue
            present(guideController, animated: true, completion: nil)
            
        }else if setting.name == SettingName.rate{
            let appId = "1355958637"
            guard let url = URL(string : "itms-apps:itunes.apple.com/us/app/apple-store/id\(appId)?mt=8&action=write-review") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func didSendFeedback() {
        Alert.showBasicAlert(title: "傳送成功", message: "訊息已傳送完成，感謝您的回饋。", vc: self)
    }
    
    
}

