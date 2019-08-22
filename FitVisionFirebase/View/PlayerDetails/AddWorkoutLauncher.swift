//
//  AddWorkoutLauncher.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/4/11.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase

class AddWorkoutLauncher: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var videoId: String?
    
    let blackView = UIView()
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        return tv
    }()
    
    let height: CGFloat = 400
    let cellId = "cellId"
    let weekDays = ["請選擇加入的時間", "週一","週二","週三", "週四","週五","週六", "週日"]

    func showWokoutDays(){
        
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            window.addSubview(tableView)
            let y = window.frame.height - height
            tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.tableView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: self.height)
            }, completion: nil)
        }
    }
    
    @objc private func handleDismiss(){
        
        if let window = UIApplication.shared.keyWindow{
        
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 0
                self.tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: self.height)
            }, completion: nil)
        }
        
    }
    
    override init() {
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if indexPath.row == 0{
            cell.textLabel?.textColor = .gray
        }
        cell.selectionStyle = .none
        cell.textLabel?.text = weekDays[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { return }
        let day = weekDays[indexPath.row]
        
        guard let uid = Auth.auth().currentUser?.uid else {
            self.handleDismiss()
            Alert.showBasicAlert(title: "請先登入", message: nil, vc: UIApplication.mainTabBarController()!)
            return
        }
        guard let videoId = videoId else { return }
        let value = ["videoId": videoId]
        Database.database().reference().child("users-workout").child(uid).child(day).updateChildValues(value) { (error, ref) in
            
            if error != nil{
                print(error ?? "add workout error")
                Alert.showBasicAlert(title: "請檢查裝置網路連線", message: nil, vc: UIApplication.mainTabBarController()!)
                return
            }
            
            self.handleDismiss()
            Alert.showBasicAlert(title: "加入成功", message: nil, vc: UIApplication.mainTabBarController()!)
        }
    }

}
