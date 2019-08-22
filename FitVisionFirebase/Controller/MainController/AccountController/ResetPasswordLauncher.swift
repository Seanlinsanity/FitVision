//
//  ResetPasswordLauncher.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordLaucher: NSObject, UITextFieldDelegate{
    
    let blackView = UIView()
    let containerView = UIView()
    
    var loginController : LoginController?
    
    let resetTitle : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "忘記密碼"
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.textAlignment = .center
        title.backgroundColor = UIColor.gray
        return title
    }()
    
    let resetGuide : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "請填入您帳戶的電子郵件，完成後您將會收到密碼設置的指引，謝謝您的使用。"
        label.numberOfLines = 3
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    let mailTextField : UITextField = {
        let mailtf = UITextField()
        mailtf.translatesAutoresizingMaskIntoConstraints = false
        mailtf.placeholder = "電子郵件"
        mailtf.backgroundColor = .white
        return mailtf
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
        return view
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "close"), for: UIControlState())
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var sendMailButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: UIControlState())
        button.backgroundColor = UIColor.rgb(red: 22, green: 171, blue: 47, alpha: 1)
        button.setTitle("確認", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleSendMail), for: .touchUpInside)
        return button
        
    }()
    
    func showPasswordRest(){
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0 ,alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleKeyboardHide)))
            
            containerView.backgroundColor = .white
            
            //add blackview before the collectionview
            window.addSubview(blackView)
            window.addSubview(containerView)
            containerView.addSubview(resetTitle)
            containerView.addSubview(cancelButton)
            containerView.addSubview(resetGuide)
            containerView.addSubview(mailTextField)
            containerView.addSubview(seperatorView)
            containerView.addSubview(sendMailButton)
            
            mailTextField.delegate = self
            mailTextField.returnKeyType = .done
            
            blackView.frame = window.frame
            blackView.alpha = 0
            containerView.frame = CGRect(x: 40, y: window.frame.height, width: window.frame.width - 80, height: 250)
            
            resetTitle.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            resetTitle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            resetTitle.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
            resetTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            cancelButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            cancelButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
            cancelButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            resetGuide.topAnchor.constraint(equalTo: resetTitle.bottomAnchor, constant: 8).isActive = true
            resetGuide.centerXAnchor.constraint(equalTo: resetTitle.centerXAnchor).isActive = true
            resetGuide.widthAnchor.constraint(equalTo: resetTitle.widthAnchor, constant: -24).isActive = true
            resetGuide.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            mailTextField.topAnchor.constraint(equalTo: resetGuide.bottomAnchor, constant: 8).isActive = true
            mailTextField.centerXAnchor.constraint(equalTo: resetTitle.centerXAnchor).isActive = true
            mailTextField.widthAnchor.constraint(equalTo: resetTitle.widthAnchor, constant: -24).isActive = true
            mailTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
            
            seperatorView.topAnchor.constraint(equalTo: mailTextField.bottomAnchor).isActive = true
            seperatorView.centerXAnchor.constraint(equalTo: mailTextField.centerXAnchor).isActive = true
            seperatorView.widthAnchor.constraint(equalTo: mailTextField.widthAnchor).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            sendMailButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
            sendMailButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            sendMailButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            sendMailButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                self.containerView.frame =  CGRect(x: 40, y: window.frame.height / 5, width: window.frame.width - 80, height: 250)
                
            }, completion: nil)
        }
        
    }
    
    @objc func handleDismiss(){
        
        handleKeyboardHide()
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            if let window = UIApplication.shared.keyWindow {
                self.blackView.alpha = 0
                self.containerView.frame =  CGRect(x: 40, y: window.frame.height + 50, width: window.frame.width - 80, height: 250)
            }
        })
    }
    
    @objc func handleKeyboardHide() {
        mailTextField.endEditing(true)
    }
    
    @objc func handleSendMail() {
        
        guard let email = mailTextField.text else{
            self.showAlertWith(title: "錯誤", message: "填寫資料格式錯誤。")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil{
                print(error ?? "error")
                self.showAlertWith(title: "錯誤", message: "電子郵件驗證失敗。")
                return
            }
            self.showAlertWith(title: "完成", message: "請至您的電子郵件確認信件。")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mailTextField.endEditing(true)
        return true
    }
    
    func showAlertWith(title: String, message: String){
        if let controller = self.loginController {
            Alert.showBasicAlert(title: title, message: message, vc: controller)
        }
    }
    
}

