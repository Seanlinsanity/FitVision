//
//  AccountUserCell.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase


class AccountUserCell: BaseCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var accountController: AccountController?
    var profileImageIsChanged: Bool?
    
    var user: UserModel? {
        
        didSet{
            
            nameLabel.text = user?.name
            if user?.profileImageUrl == nil {
                userImageButton.setImage(UIImage(), for: .normal)
                userImageButton.setTitle(user?.userAbbreviation, for: .normal)
            }
            
            guard let imageUrl = user?.profileImageUrl else { return }
            guard let url = URL(string: imageUrl) else { return }
            downloadprofileImage(url)
            
        }
    }
    
    func downloadprofileImage(_ url: URL) {
        
        if profileImageIsChanged == true {
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: {(data, respones, error) in
            
            if error != nil {
                print(error ?? "error")
                return
            }
            DispatchQueue.main.async (execute: {
                
                guard let imageData = data else { return }
                if let downloadImage = UIImage(data: imageData) {
                    self.userImageButton.setImage(downloadImage.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.userImageButton.titleLabel?.text = nil
                }
                
                self.profileImageIsChanged = true
            })
            
        }).resume()
    }
    
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var userImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFill
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 50
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleEditPhoto), for: .touchUpInside)
        return button
    }()
    
    lazy var cameraButton : UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleEditPhoto), for: .touchUpInside)
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        
        addSubview(nameLabel)
        addSubview(userImageButton)
        
        userImageButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        userImageButton.topAnchor.constraint(equalTo: topAnchor, constant: 32).isActive = true
        userImageButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        userImageButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        nameLabel.centerXAnchor.constraint(equalTo: userImageButton.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: userImageButton.bottomAnchor, constant: 24).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(cameraButton)
        cameraButton.centerXAnchor.constraint(equalTo: userImageButton.centerXAnchor).isActive = true
        cameraButton.topAnchor.constraint(equalTo: userImageButton.bottomAnchor).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    @objc private func handleEditPhoto(){
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "從相片圖庫中選取", style: .default, handler: { (_) in
            self.handleOpenPhotoLibrary()
        }))
        alertController.addAction(UIAlertAction(title: "拍照", style: .default, handler: { (_) in
            self.handleAcessCamera()
        }))
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        accountController?.present(alertController, animated: true, completion: nil)
    }
    
    private func handleOpenPhotoLibrary(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.navigationBar.isTranslucent = false
        imagePickerController.navigationBar.barTintColor = .mainGreen
        imagePickerController.navigationBar.tintColor = .white
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        accountController?.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func handleAcessCamera(){
        let cameraController = CameraController()
        cameraController.accountUserCell = self
        accountController?.present(cameraController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            userImageButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            userImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        userImageButton.titleLabel?.text = nil
        profileImageIsChanged = true
        
        storeImageInFirebase()
        accountController?.dismiss(animated: true, completion: nil)
    }
    
    private func storeImageInFirebase(){
        
        guard let image = userImageButton.imageView?.image else { return }
        guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let filename = NSUUID().uuidString
        
        Storage.storage().reference().child("profile_image").child(uid).child(filename).putData(uploadData, metadata: nil) { (meta, err) in
            
            if err != nil {
                print("failed to uplaod profile image", err ?? "error")
                return
            }
            
            guard let profileImageUrl = meta?.downloadURL()?.absoluteString else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
           
            let value = ["profileImageUrl": profileImageUrl]
            let ref = Database.database().reference().child("users").child(uid)
            ref.updateChildValues(value, withCompletionBlock: { (error, ref) in
                if error != nil {
                    return
                }

            })
        }
        
    }
    
    func handleCameraPhoto(image: UIImage) {
        
        userImageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        userImageButton.titleLabel?.text = nil
        profileImageIsChanged = true
        
        storeImageInFirebase()
    }
    
    
    
}

