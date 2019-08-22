//
//  AccountController.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase

class AccountSetting: NSObject{
    var name: String?
    var imageName: String?
}

class AccountController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    let userId = "userId"
    let workoutId = "workoutId"
    let settingId = "setting"
    let statusId = "statusId"
    let titleId = "titleId"
    
    let user = UserModel()
    var workouts = [Workout]()
    
    var userNumberOfViews: String?
    var userNumberOfLikes: String?
    var accountSettings = [AccountSetting]()
    
    
    let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero , collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        return cv
        
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
    }
    
    private func setupNavigationbar(){
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 2.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.3
        
        setupNavBarTitle(title: "  我的帳戶")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationbar()
        setupCollectionView()
        checkIfLoggedin()
        setupViewLayout()
        setupSettingCell()
    }
    
    private func setupCollectionView(){
        collectionView.register(AccountUserCell.self, forCellWithReuseIdentifier: userId)
        collectionView.register(AccountSettingCell.self, forCellWithReuseIdentifier: settingId)
        collectionView.register(AccountWorkoutCell.self, forCellWithReuseIdentifier: workoutId)
        collectionView.register(AccountStatusCell.self, forCellWithReuseIdentifier: statusId)
        collectionView.register(TitleCell.self, forCellWithReuseIdentifier: titleId)
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupSettingCell() {
        
        let logoutSetting = AccountSetting()
        logoutSetting.name = "登出"
        logoutSetting.imageName = "logout"
        let emailSetting = AccountSetting()
        emailSetting.imageName = "mail"
        
        accountSettings = [emailSetting,logoutSetting]
    }
    
    
    func setupViewLayout() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func handleDeleteWorkout(workouts: [Workout]?){
        self.workouts = workouts ?? [Workout]()
        let indexPath = IndexPath(row: 1, section: 0)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accountSettings.count + 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userId, for: indexPath) as! AccountUserCell
            cell.accountController = self
            cell.user = user
            return cell
        }else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: workoutId, for: indexPath) as! AccountWorkoutCell
            cell.workouts = workouts
            cell.accountController = self
            return cell
        }else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: statusId, for: indexPath) as! AccountStatusCell
            cell.numberOfLike.text = userNumberOfLikes
            cell.numberOfPlay.text = userNumberOfViews
            return cell
        }else if indexPath.item == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: titleId, for: indexPath) as! TitleCell
            cell.nameLabel.text = "帳戶"
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: settingId, for: indexPath) as! AccountSettingCell
            cell.accountSetting = accountSettings[indexPath.item - 4]
            
            if indexPath.item == 4 {
                cell.nameLabel.text = user.email
                cell.nameLabel.textColor = .black
                cell.iconImageView.tintColor = UIColor.rgb(red: 22, green: 171, blue: 47, alpha: 1)
            }
            
            if indexPath.item == 5 {
                cell.nameLabel.textColor = .red
                cell.iconImageView.tintColor = .red
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0 {
            return CGSize(width: collectionView.frame.width, height: 210)
        }else if indexPath.item == 1 {
            return CGSize(width: collectionView.frame.width, height: CGFloat(158 + (60 + 12) * workouts.count))
        }else if indexPath.item == 2 {
            return CGSize(width: collectionView.frame.width, height: 456)
        }else{
            return CGSize(width: collectionView.frame.width, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 5 {
            handleLogout()
        }
    }
    
    func checkIfLoggedin() {
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
            fetchUserName()
            fetchUserWorkout()
        }
        
    }
    
    @objc private func handleLogout() {
        
        let uid = Auth.auth().currentUser?.uid ?? "noUser"
        Database.database().reference().child("users").child(uid).child("fcmToken").removeValue()
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    func handleReload(){
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
}

