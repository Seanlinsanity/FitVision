//
//  Extension.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Alamofire
import youtube_ios_player_helper

extension UIApplication{
    static func mainTabBarController() -> CustomTabBarController?{
        return shared.keyWindow?.rootViewController as? CustomTabBarController
    }
}


extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    static var mainGreen = UIColor.rgb(red: 22, green: 171, blue: 47, alpha: 1)
    static var darkGreen = UIColor.rgb(red: 14, green: 113, blue: 31, alpha: 1)
    static var lightGreen = UIColor.rgb(red: 28, green: 217, blue: 60, alpha: 1)
    
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
            
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
}
