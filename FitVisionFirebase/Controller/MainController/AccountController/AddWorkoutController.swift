//
//  AddWorkoutController.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/4/9.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase

class AddWorkoutController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, SelectVideoDelegate{
    
    var originalWorkoutDay: String?
    var workout: Workout?{
        didSet{
            let videos = HomeApiService.sharedInstance.videos
            guard let index = videos.index(where: {$0.videoId == workout?.videoId}) else { return }
            let video = videos[index]
            
            let urlString = video.thumbnailImageUrl
            if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
                selectVideoBtn.setImage(imageFromCache.withRenderingMode(.alwaysOriginal), for: .normal)
                selectVideoBtn.layer.borderWidth = 0
            }
            videoTitleLabel.text = video.title
        }
    }
    
    let weeks = ["週一","週二","週三", "週四","週五","週六", "週日"]
    
    let videoLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "選擇影片"
        lb.textColor = UIColor.lightGray
        lb.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return lb
    }()
    
    let selectVideoBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.imageView?.contentMode = .scaleAspectFill
        btn.setImage(#imageLiteral(resourceName: "add_video").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.layer.cornerRadius = 8
        btn.imageView?.clipsToBounds = true
        btn.tintColor = .mainGreen
        btn.layer.borderColor = UIColor.mainGreen.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(handleSelectVideo), for: .touchUpInside)
        return btn
    }()
    
    let videoTitleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = ""
        lb.numberOfLines = 0
        lb.textColor = UIColor.black
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return lb
    }()
    
    let dayLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "選擇時間"
        lb.textColor = UIColor.lightGray
        lb.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return lb
    }()
    
    let dayPicker: UIPickerView = {
        let pv = UIPickerView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
    fileprivate func setupNavigationBar() {
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(handleCancel))
        cancelButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)], for: .normal)
        navigationItem.leftBarButtonItem = cancelButton
        
        let addButton = UIBarButtonItem(title: "加入", style: .plain, target: self, action: #selector(handleDidAdd))
        addButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)], for: .normal)
        navigationItem.rightBarButtonItem = addButton
    }
    
    var videoTitleHeightAnchor: NSLayoutConstraint?
    fileprivate func setupUI() {
        view.addSubview(videoLabel)
        videoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        if #available(iOS 11.0, *) {
            videoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        } else {
            videoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        }
        videoLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        videoLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(selectVideoBtn)
        selectVideoBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        selectVideoBtn.topAnchor.constraint(equalTo: videoLabel.bottomAnchor, constant: 8).isActive = true
        selectVideoBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        selectVideoBtn.heightAnchor.constraint(equalToConstant: (view.frame.width - 32) * 9/16).isActive = true
        
        view.addSubview(videoTitleLabel)
        videoTitleLabel.leftAnchor.constraint(equalTo: selectVideoBtn.leftAnchor).isActive = true
        videoTitleLabel.topAnchor.constraint(equalTo: selectVideoBtn.bottomAnchor, constant: 8).isActive = true
        videoTitleLabel.rightAnchor.constraint(equalTo: selectVideoBtn.rightAnchor).isActive = true
        if workout != nil{
            videoTitleHeightAnchor = videoTitleLabel.heightAnchor.constraint(equalToConstant: 48)
        }else{
            videoTitleHeightAnchor = videoTitleLabel.heightAnchor.constraint(equalToConstant: 0)
            
        }
        videoTitleHeightAnchor?.isActive = true
        
        view.addSubview(dayLabel)
        dayLabel.topAnchor.constraint(equalTo: videoTitleLabel.bottomAnchor, constant: 8).isActive = true
        dayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        dayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        dayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(dayPicker)
        dayPicker.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: -16).isActive = true
        dayPicker.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        dayPicker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        dayPicker.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .mainGreen
        
        dayPicker.delegate = self
        dayPicker.dataSource = self
        
        setupNavigationBar()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let weekIndex = weeks.index(of: workout?.day ?? "") else { return }
        dayPicker.selectRow(weekIndex, inComponent: 0, animated: true)

    }
    
    @objc private func handleSelectVideo(){
        let selectVideoController = SelectVideoController(collectionViewLayout: UICollectionViewFlowLayout())
        selectVideoController.delegate = self
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.pushViewController(selectVideoController, animated: true)
    }
    
    func selectVideo(video: Video) {
        let urlString = video.thumbnailImageUrl
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            let image = imageFromCache
            selectVideoBtn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            selectVideoBtn.layer.borderWidth = 0
        }
        if workout == nil{
            workout = Workout(day: nil, videoId: video.videoId)
        }else{
            workout?.videoId = video.videoId
        }
        videoTitleHeightAnchor?.constant = 48
        videoTitleLabel.text = video.title
    }
    
    @objc private func handleDidAdd(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let videoId = workout?.videoId else {
            Alert.showBasicAlert(title: "請選擇一部影片", message: nil, vc: self)
            return
        }
        let day = workout?.day ?? "週一"
        let value = ["videoId" : videoId] as [String : Any]
        
        Database.database().reference().child("users-workout").child(uid).child(day).updateChildValues(value) { (error, ref) in
            if error != nil{
                print(error ?? "workout update error")
                Alert.showBasicAlert(title: "錯誤", message: "請檢查連線狀態", vc: self)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
        
        checkOriginalWorkoutDay(day: day)
    }
    
    private func checkOriginalWorkoutDay(day: String){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let originalDay = originalWorkoutDay else { return }
        if day != originalDay{
            Database.database().reference().child("users-workout").child(uid).child(originalDay).removeValue(completionBlock: { (error, ref) in
                if error != nil{
                    return
                }
            })
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weeks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weeks[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if workout == nil {
            workout = Workout(day: weeks[row], videoId: nil)
        }else{
            workout?.day = weeks[row]
        }
    }
    
    @objc private func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
}
