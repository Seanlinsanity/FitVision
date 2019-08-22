//
//  FeedbackLauncher.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//


import UIKit
import Firebase

protocol FeedbackDelegate {
    func didSendFeedback()
}

class FeedbackLauncher: NSObject, UITextViewDelegate {
    
    var delegate: FeedbackDelegate?
    let placeholder = "我們可以如何改善？"
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .white
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = placeholder
        tv.textColor = UIColor.lightGray
        tv.delegate = self
        return tv
    }()
    
    let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        return view
    }()
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "意見回饋"
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        return lb
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("取消", for: UIControlState())
        button.setTitleColor(UIColor.rgb(red: 17, green: 121, blue: 47, alpha: 1), for: UIControlState())
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("傳送", for: UIControlState())
        button.setTitleColor(UIColor.rgb(red: 17, green: 121, blue: 47, alpha: 1), for: UIControlState())
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    let blackView = UIView()
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    func setupFeedback(){
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0 ,alpha: 0.7)
            containerView.alpha = 1
            containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEndEditing)))
            
            window.addSubview(blackView)
            window.addSubview(containerView)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            containerView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height)
            
            containerView.addSubview(textView)
            containerView.addSubview(titleView)
            
            textView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            textView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -window.frame.height / 8).isActive = true
            textView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7).isActive = true
            textView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.4).isActive = true
            
            titleView.centerXAnchor.constraint(equalTo: textView.centerXAnchor).isActive = true
            titleView.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true
            titleView.widthAnchor.constraint(equalTo: textView.widthAnchor).isActive = true
            titleView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            titleView.addSubview(titleLabel)
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalTo: titleView.widthAnchor).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
            titleLabel.heightAnchor.constraint(equalTo: titleView.heightAnchor).isActive = true
            
            titleView.addSubview(cancelButton)
            cancelButton.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
            cancelButton.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
            cancelButton.heightAnchor.constraint(equalTo: titleView.heightAnchor).isActive = true
            cancelButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            
            titleView.addSubview(sendButton)
            sendButton.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
            sendButton.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
            sendButton.heightAnchor.constraint(equalTo: titleView.heightAnchor).isActive = true
            sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            
            titleView.addSubview(seperatorView)
            seperatorView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
            seperatorView.widthAnchor.constraint(equalTo: titleView.widthAnchor).isActive = true
            seperatorView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
            }, completion: { (_) in
                self.showTextViewAnimation()
                
            })
        }
    }
    
    private func showTextViewAnimation(){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            if let window = UIApplication.shared.keyWindow{
                self.containerView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            }
            
        }, completion: { (_) in
            self.textView.becomeFirstResponder()
        })
    }
    
    @objc private func handleEndEditing() {
        textView.endEditing(true)
    }
    
    @objc private func handleCancel(){
        textView.endEditing(true)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                self.containerView.frame = CGRect(x: 0, y: window.frame.height + 100, width: window.frame.width, height: window.frame.height)
            }
            
        })
    }
    
    @objc func handleSend(){
        let uId = Auth.auth().currentUser?.uid ?? "nil"
        guard let text = textView.text else { return }
        let value = ["comment" : text]
        Database.database().reference().child("users-feedback").child(uId).childByAutoId().updateChildValues(value) { (error, ref) in
            if error != nil {
                print(error ?? "failed to send feedback")
                return
            }
            self.textView.text = nil
            self.handleCancel()
            self.delegate?.didSendFeedback()
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
    
}

