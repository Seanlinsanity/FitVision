//
//  VideoInfoCell.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase

class VideoInfoCell: BaseCell {
    
    var userLikeVideos = [String]()
    var playerDetailsView: PlayerDetailsView?
    var isLiked: Bool?
    var userId: String?
    var descriptionIsHidden = true
    var isTwoLinesTitle: Bool?
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    var categoryTagButtonWidthConstraint: NSLayoutConstraint?
    
    var video: Video? {
        
        didSet{
            
            titleLabel.text = video?.title
            guard let twoLines = isTwoLinesTitle else { return }
            if twoLines {
                titleLabelHeightConstraint?.constant = 48
            }else{
                titleLabelHeightConstraint?.constant = 24
            }
            setupTagButton()

            if descriptionIsHidden {
                descriptionButton.setImage(#imageLiteral(resourceName: "more_down").withRenderingMode(.alwaysTemplate), for: .normal)
            }else{
                descriptionButton.setImage(#imageLiteral(resourceName: "more_up").withRenderingMode(.alwaysTemplate), for: .normal)
            }
            playerDetailsView?.showDescription(descriptionIsHidden: descriptionIsHidden)
            
            channelLabelBtn.setTitle(video?.channel?.name, for: .normal)
            userLikeVideos = [String]()
            
            guard let uid = Auth.auth().currentUser?.uid else{
                print("not log in")
                isLiked = false
                setupLikeButton()
                
                return
            }
            userId = uid
            readUserLike(uid: uid)
        }
    }
    
    private func setupTagButton(){
        if video?.categories.isEmpty ?? true  { return }
        difficultyTagButton.setTitle(video?.categories[0], for: .normal)
        if video?.categories[0] == "初階"{
            difficultyTagButton.backgroundColor = UIColor.rgb(red: 28, green: 217, blue: 60, alpha: 1)
        }else if video?.categories[0] == "進階"{
            difficultyTagButton.backgroundColor = UIColor.mainGreen
        }else{
            difficultyTagButton.backgroundColor = UIColor.rgb(red: 14, green: 113, blue: 31, alpha: 1)
        }
        categoryTagButton.setTitle(video?.categories[1], for: .normal)
        categoryTagButtonWidthConstraint?.constant = video?.categories[1].count ?? 0 > 3 ? 100 : 80
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Title here!"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var channelLabelBtn: UIButton = {
        let channelBtn = UIButton(type: .system)
        channelBtn.translatesAutoresizingMaskIntoConstraints = false
        channelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        channelBtn.titleLabel?.textAlignment = .left
        channelBtn.contentHorizontalAlignment = .left
        channelBtn.tintColor = .gray
        channelBtn.addTarget(self, action: #selector(handleChannel), for: .touchUpInside)
        return channelBtn
    }()
    
    
    lazy var difficultyTagButton: UIButton = {
        let tagBtn = UIButton(type: .system)
        tagBtn.translatesAutoresizingMaskIntoConstraints = false
        tagBtn.backgroundColor = UIColor.rgb(red: 22, green: 171, blue: 47, alpha: 1)
        tagBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        tagBtn.tintColor = .white
        tagBtn.titleLabel?.textAlignment = .center
        tagBtn.clipsToBounds = true
        tagBtn.layer.cornerRadius = 15
        tagBtn.layer.masksToBounds = true
        tagBtn.addTarget(self, action: #selector(handleDifficultyTag), for: .touchUpInside)
        return tagBtn
    }()
    
    lazy var categoryTagButton: UIButton = {
        let tagBtn = UIButton(type: .system)
        tagBtn.translatesAutoresizingMaskIntoConstraints = false
        tagBtn.backgroundColor = .orange
        tagBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        tagBtn.tintColor = .white
        tagBtn.titleLabel?.textAlignment = .center
        tagBtn.clipsToBounds = true
        tagBtn.layer.cornerRadius = 15
        tagBtn.layer.masksToBounds = true
        tagBtn.addTarget(self, action: #selector(handleCategoryTag), for: .touchUpInside)
        return tagBtn
    }()
    
    let border: UIView = {
        let border = UIView()
        border.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        border.translatesAutoresizingMaskIntoConstraints = false
        return border
    }()
    
    let buttonborder: UIView = {
        let border = UIView()
        border.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        border.translatesAutoresizingMaskIntoConstraints = false
        return border
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "like")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle(" 收藏", for: .normal)
        button.tintColor = .gray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "share")
        button.setTitle(" 分享", for: .normal)
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "add")
        button.setTitle(" 加入計畫", for: .normal)
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleAddWorkout), for: .touchUpInside)
        return button
    }()
    
    lazy var addWorkoutLauncher = AddWorkoutLauncher()

    @objc func handleAddWorkout(){
        addWorkoutLauncher.videoId = video?.videoId
        addWorkoutLauncher.showWokoutDays()
    }
    
    lazy var descriptionButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "more_down")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .darkGray
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(showDescription), for: .touchUpInside)
        return button
    }()
    
    func setupLikeButton(){
        guard let isLiked = isLiked else { return }
        if !isLiked {
            likeButton.tintColor = UIColor.gray
            likeButton.setTitle(" 收藏", for: .normal)
        }else{
            likeButton.tintColor = .mainGreen
            likeButton.setTitle(" 已收藏", for: .normal)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        setupButtonStackView()
        addSubview(titleLabel)
        addSubview(descriptionButton)
        addSubview(channelLabelBtn)
        addSubview(difficultyTagButton)
        addSubview(categoryTagButton)
        addSubview(border)
        
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -32).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 25)
        titleLabelHeightConstraint?.isActive = true
        
        descriptionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        descriptionButton.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 6).isActive = true
        descriptionButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        descriptionButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        channelLabelBtn.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        channelLabelBtn.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        channelLabelBtn.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        channelLabelBtn.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        difficultyTagButton.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        difficultyTagButton.topAnchor.constraint(equalTo: channelLabelBtn.bottomAnchor, constant: 4).isActive = true
        difficultyTagButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        difficultyTagButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        categoryTagButton.leftAnchor.constraint(equalTo: difficultyTagButton.rightAnchor, constant: 8).isActive = true
        categoryTagButton.topAnchor.constraint(equalTo: difficultyTagButton.topAnchor).isActive = true
        categoryTagButtonWidthConstraint = categoryTagButton.widthAnchor.constraint(equalToConstant: 80)
        categoryTagButtonWidthConstraint?.isActive = true
        categoryTagButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        border.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        border.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        border.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    private func setupButtonStackView(){
        let stackView = UIStackView(arrangedSubviews: [likeButton, shareButton, addButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(buttonborder)
        buttonborder.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        buttonborder.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        buttonborder.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -12).isActive = true
        buttonborder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    @objc func showDescription() {
        
        descriptionIsHidden = !descriptionIsHidden
        
        if descriptionIsHidden {
            descriptionButton.setImage(#imageLiteral(resourceName: "more_down").withRenderingMode(.alwaysTemplate), for: .normal)
        }else{
            descriptionButton.setImage(#imageLiteral(resourceName: "more_up").withRenderingMode(.alwaysTemplate), for: .normal)
        }
        playerDetailsView?.showDescription(descriptionIsHidden: descriptionIsHidden)
    }
    
    @objc private func handleDifficultyTag(){
        guard let tag = difficultyTagButton.titleLabel?.text else { return }
        showTagController(tag: tag)
    }
    
    @objc private func handleCategoryTag(){
        guard let tag = categoryTagButton.titleLabel?.text else { return }
        showTagController(tag: tag)
    }
    
    private func showTagController(tag: String){
        UIApplication.mainTabBarController()?.minimizePlayerDetails()
        
        if UIApplication.mainTabBarController()?.selectedIndex == 1{
            let hotVC = getHotVC()
            hotVC?.handleShowCategoryController(category: tag)
            
        }else{
            UIApplication.mainTabBarController()?.selectedIndex = 0
            let homeVC = getHomeVC()
            homeVC?.handleMoreCategoryVideos(category: tag)
        }
    }
    
    @objc private func handleChannel(){
        guard let channel = channelLabelBtn.titleLabel?.text else { return }
        
        UIApplication.mainTabBarController()?.minimizePlayerDetails()
        
        if UIApplication.mainTabBarController()?.selectedIndex == 1{
            let hotVC = getHotVC()
            hotVC?.handleShowChannelController(channel: channel)
            
        }else{
            UIApplication.mainTabBarController()?.selectedIndex = 0
            let homeVC = getHomeVC()
            homeVC?.handleShowChannelController(channel: channel)
        }
    }
    
    private func getHotVC() -> HotController?{
        let hotNavController = UIApplication.mainTabBarController()?.viewControllers?[1] as? UINavigationController
        let hotVC = hotNavController?.viewControllers.first as? HotController
        return hotVC
    }
    
    private func getHomeVC() -> HomeController?{
        let homeNavController = UIApplication.mainTabBarController()?.viewControllers?[0] as? UINavigationController
        let homeVC = homeNavController?.viewControllers.first as? HomeController
        return homeVC
    }
}

