//
//  PreviewPhotoContainerView.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/3/15.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Photos

protocol CameraDelegate {
    func didSaveCameraPhoto(image: UIImage)
}

class PreviewPhotoContainerView: UIView {
    
    var delegate: CameraDelegate?
    
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleCancel(){
        self.removeFromSuperview()
    }
    
    @objc func handleSave(){
        
        guard let previewImage = previewImageView.image else { return }
        
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
            
        }) { (success, err) in
            if let err = err {
                print("failed to save photo to photo library:", err)
            }
        }
        print("successfully save photo to photo library")
        delegate?.didSaveCameraPhoto(image: previewImage)
        
        DispatchQueue.main.async {
            let savedLabel = UILabel()
            savedLabel.text = "儲存完成"
            savedLabel.textColor = .white
            savedLabel.textAlignment = .center
            savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
            savedLabel.numberOfLines = 0
            savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
            
            savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
            savedLabel.center = self.center
            self.addSubview(savedLabel)
            
            savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                
                savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                
            }, completion: { (_) in
                UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    
                    savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                    savedLabel.alpha = 0
                    
                }, completion: { (_) in
                    savedLabel.removeFromSuperview()
                })
            })
            self.addSubview(savedLabel)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(previewImageView)
        previewImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        previewImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        previewImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        previewImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(cancelButton)
        cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        addSubview(saveButton)
        saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24).isActive = true
        saveButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
