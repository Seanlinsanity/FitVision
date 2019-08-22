//
//  UIViewController_extension.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/5/5.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func setupNavBarLogo() -> (UILabel, UIImageView){
        
        let titleLabel : UILabel = {
            let titlelb = UILabel()
            titlelb.text = " FitVision"
            titlelb.textColor = UIColor.white
            titlelb.font = UIFont.boldSystemFont(ofSize: 20)
            titlelb.translatesAutoresizingMaskIntoConstraints = false
            return titlelb
        }()
        
        let logoImageView: UIImageView = {
            let logo = UIImageView()
            logo.translatesAutoresizingMaskIntoConstraints = false
            logo.image = #imageLiteral(resourceName: "logo_clear")
            logo.contentMode = .scaleAspectFit
            return logo
        }()
        
        setupNavBarLogoUI(titleLabel: titleLabel, logoImageView: logoImageView)
        
        return (titleLabel, logoImageView)
    }
    
    func setupNavBarLogoUI(titleLabel: UILabel ,logoImageView: UIImageView){
        navigationController?.navigationBar.addSubview(logoImageView)
        navigationController?.navigationBar.addSubview(titleLabel)
        
        guard let navigationBar = navigationController?.navigationBar else{ return }
        logoImageView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 16).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupNavBarTitle(title: String){
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = title
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
    }
    
    
}
