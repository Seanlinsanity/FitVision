//
//  RegisterController.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: LoginController {
    
    let nameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = " 名字"
        tf.backgroundColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let nameSeperatorView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var registerButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("建立新帳號", for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.rgb(red: 93, green: 196, blue: 110, alpha: 1)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var haveAccountButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("已經有帳號? 馬上登入", for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.5)
        button.backgroundColor = UIColor.clear
        button.tintColor = .white
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleHaveAccount), for: .touchUpInside)
        
        return button
    }()
    

    @objc func handleRegister() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else{
            print("Form is not valid")
            return
        }
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error) in
            
            if error != nil{
                self.activityIndicatorView.stopAnimating()
                Alert.showBasicAlert(title: "註冊失敗", message: "電子郵件格式有誤，或是此電子郵件已被註冊過。", vc: self)
                return
            }

            guard let uid = user?.uid else { return }

            let ref = Database.database().reference()
            let userReference = ref.child("users").child(uid)
            let values = ["name" : name, "email" : email]
            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    self.activityIndicatorView.stopAnimating()
                    Alert.showBasicAlert(title: "錯誤", message: "請檢查網路連線。", vc: self)
                    return
                }
                self.showAccount()
            })
        }
    }
    
    @objc func handleHaveAccount() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func setupTextField() {
        view.addSubview(inputContainer)
        view.addSubview(registerButton)
        view.addSubview(logoImage)
        view.addSubview(haveAccountButton)
        
        inputContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        inputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        inputContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        if view.frame.height < 500 {
            inputContainer.heightAnchor.constraint(equalToConstant: 120).isActive = true
        }else{
            inputContainer.heightAnchor.constraint(equalToConstant: 165).isActive = true
        }
        
        registerButton.centerXAnchor.constraint(equalTo: inputContainer.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: 16).isActive = true
        registerButton.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3).isActive = true
        
        logoImage.bottomAnchor.constraint(equalTo: inputContainer.topAnchor, constant: 0).isActive = true
        logoImage.centerXAnchor.constraint(equalTo: inputContainer.centerXAnchor).isActive = true
        if view.frame.height < 500 {
            logoImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
            logoImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        }else{
            logoImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
            logoImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        }
        
        inputContainer.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: inputContainer.topAnchor).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: inputContainer.centerXAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainer.widthAnchor, constant: -24).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3).isActive = true
        
        nameTextField.addSubview(nameSeperatorView)
        nameSeperatorView.bottomAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperatorView.centerXAnchor.constraint(equalTo: nameTextField.centerXAnchor).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        
        inputContainer.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: inputContainer.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainer.widthAnchor, constant: -24).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3).isActive = true
        
        emailTextField.addSubview(emailSeperatorView)
        emailSeperatorView.bottomAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperatorView.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        
        inputContainer.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo:emailTextField.heightAnchor).isActive = true
        
        haveAccountButton.centerXAnchor.constraint(equalTo: inputContainer.centerXAnchor).isActive = true
        haveAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        haveAccountButton.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        haveAccountButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor, multiplier: 4/5).isActive = true
    }
}

