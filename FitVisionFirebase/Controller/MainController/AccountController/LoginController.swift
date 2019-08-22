//
//  LoginController.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController, UITextFieldDelegate {
    
    let logoImage : UIImageView = {
        
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.image = #imageLiteral(resourceName: "logo_word")
        logo.contentMode = .scaleAspectFit
        return logo
    }()
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = " 電子郵件"
        tf.backgroundColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let emailSeperatorView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " 密碼"
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let inputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var resetPasswordLauncher : ResetPasswordLaucher = {
        let launcher = ResetPasswordLaucher()
        launcher.loginController = self
        return launcher
    }()
    
    lazy var loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("登入", for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.rgb(red: 93, green: 196, blue: 110, alpha: 1)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    lazy var resetPasswordButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("忘記密碼？", for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        
        return button
    }()
    
    lazy var createAccountButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("建立新帳號", for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.5)
        button.backgroundColor = UIColor.clear
        button.tintColor = .white
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(showRegisterView), for: .touchUpInside)
        
        return button
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.color = .darkGray
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.layer.masksToBounds = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = .clear
        view.backgroundColor = UIColor.rgb(red: 22, green: 171, blue: 47, alpha: 1)
        
        setupTextField()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        passwordTextField.delegate = self
        emailTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc func handleLogin() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else{
            print("Form is not valid")
            return
        }
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatorView.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                print(error ?? "sign in error")
                self.activityIndicatorView.stopAnimating()
                Alert.showBasicAlert(title: "錯誤", message: "登入失敗，請再次確認您輸入正確的帳戶資訊。", vc: self)
                return
            }
            
            print("successfully sign in")
            
            self.activityIndicatorView.stopAnimating()
            self.showAccount()
            
            guard let fcmToken = Messaging.messaging().fcmToken else { return }
            guard let uid = user?.uid else { return }
            let value = ["fcmToken": fcmToken]
            Database.database().reference().child("users").child(uid).updateChildValues(value, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print("fcmToken update failed")
                    return
                }
                print("successfully update fcmToken")
            })
            
        }
    }
    
    @objc func handleResetPassword() {
        resetPasswordLauncher.showPasswordRest()
    }
    
    func showAccount() {
        let accoutController = AccountController()
        navigationController?.pushViewController(accoutController, animated: true)
    }
    
    @objc func showRegisterView() {
        
        let registerController = RegisterController()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.pushViewController(registerController, animated: true)
    }
    
    func setupTextField() {
        
        view.addSubview(inputContainer)
        view.addSubview(loginButton)
        view.addSubview(logoImage)
        view.addSubview(resetPasswordButton)
        view.addSubview(createAccountButton)
        
        inputContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16).isActive = true
        inputContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        inputContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        if view.frame.height < 500 {
            inputContainer.heightAnchor.constraint(equalToConstant: 70).isActive = true
        }else{
            inputContainer.heightAnchor.constraint(equalToConstant: 110).isActive = true
        }
        loginButton.centerXAnchor.constraint(equalTo: inputContainer.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: 16).isActive = true
        loginButton.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/2).isActive = true
        
        resetPasswordButton.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        resetPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 4).isActive = true
        resetPasswordButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor).isActive = true
        resetPasswordButton.heightAnchor.constraint(equalTo: loginButton.heightAnchor, multiplier: 3/5).isActive = true
        
        logoImage.bottomAnchor.constraint(equalTo: inputContainer.topAnchor, constant: -32).isActive = true
        logoImage.centerXAnchor.constraint(equalTo: inputContainer.centerXAnchor).isActive = true
        if view.frame.height < 500 {
            logoImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
            logoImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        }else{
            logoImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
            logoImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        }
        
        inputContainer.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: inputContainer.topAnchor).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: inputContainer.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainer.widthAnchor, constant: -24).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/2).isActive = true
        
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
        
        createAccountButton.centerXAnchor.constraint(equalTo: inputContainer.centerXAnchor).isActive = true
        createAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        createAccountButton.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        createAccountButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor, multiplier: 4/5).isActive = true
    }
    
}

