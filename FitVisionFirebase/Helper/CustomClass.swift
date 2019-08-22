//
//  CustomClass.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/22.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Alamofire

class CustomButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let imageView = self.imageView else {return}
        guard let title = self.titleLabel else { return }
        
        var center = imageView.center
        center.x = self.frame.size.width / 2
        center.y = imageView.frame.size.height / 2
        
        self.imageView?.center = center
        
        var frame = title.frame
        
        frame.origin.x = 0;
        frame.origin.y = imageView.frame.size.height + 6
        frame.size.width = self.frame.size.width
        
        self.titleLabel?.frame = frame
        self.titleLabel?.textAlignment = .center
    }
    
}

class Connectivity {
    
    class var isConnectedToInternet:Bool {
        if let networkReachabilityManager = NetworkReachabilityManager(){
            return networkReachabilityManager.isReachable
        }
        return false
    }
}

struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
}

let paragraphStyle: NSMutableParagraphStyle = {
    let ps = NSMutableParagraphStyle()
    ps.alignment = .left
    return ps
}()

class Alert {
    
    class func showBasicAlert(title: String, message: String?, vc: UIViewController){
        
        let messageText = NSMutableAttributedString(
            string: message ?? "",
            attributes: [
                NSAttributedStringKey.paragraphStyle: paragraphStyle,
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13),
                NSAttributedStringKey.foregroundColor : UIColor.black
            ]
        )
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.setValue(messageText, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "關閉", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


