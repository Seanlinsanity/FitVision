//
//  ReconnectedInternetCell.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/22.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

protocol ReconnectDelegate {
    func hadleReconnect()
}

class ReconnectCell: BaseCell {
    
    var delegate: ReconnectDelegate?
    
    lazy var reconnectedBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("  再試一次", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.setTitleColor(.mainGreen, for: .normal)
        btn.setImage(#imageLiteral(resourceName: "refresh"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .mainGreen
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        return btn
    }()
    
    @objc private func handleRefresh(){
        delegate?.hadleReconnect()
    }
    
    
    
    override func setupViews() {
        super.setupViews()
        addSubview(reconnectedBtn)
        
        reconnectedBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        reconnectedBtn.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50).isActive = true
        reconnectedBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        reconnectedBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
}
