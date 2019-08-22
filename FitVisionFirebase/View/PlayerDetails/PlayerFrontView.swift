//
//  PlayerFrontView.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

protocol PlayerFrontViewDelegate {
    func handleFullScreen()
    func handlePausePlay()
    func handleSliderChange()
}

class PlayerFrontView: UIView {
    
    var video: Video?{
        didSet{
            
            subtitleTextWidthConstraint?.constant = 0
            subtitleText.text = ""
            subtitleIsShowing = true
            subtitleText.isHidden = false
            subtitleButton.tintColor = .white
            
            checkSubtitleAvailable()
            setupVideoDuration()
            pausePlayButton.setImage(UIImage(named: "pause"), for: UIControlState())
        }
    }
    
    var delegate: PlayerFrontViewDelegate?
    
    var subtitleIsShowing = true
    
    weak var tapTimer: Timer?
    
    var subtitleTextBottomConstraint: NSLayoutConstraint?
    var subtitleTextHeightConstraint: NSLayoutConstraint?
    var subtitleTextWidthConstraint: NSLayoutConstraint?
    var currentTimeLabelWidth: NSLayoutConstraint?
    var currentTimeLabelHeight: NSLayoutConstraint?
    var durationLabelWidth: NSLayoutConstraint?
    var durationLabelHeight: NSLayoutConstraint?
    var fullscreenWidth: NSLayoutConstraint?
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(white: 0.95, alpha: 0.7)
        button.addTarget(self, action: #selector(handlePausePlay), for: .touchUpInside)
        return button
        
    }()
    
    lazy var dissmissButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "dragDown")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(handleShrinkVideoView), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func handleShrinkVideoView(){
        UIApplication.mainTabBarController()?.minimizePlayerDetails()
    }
    
    let fullScreenButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "fullscreen")
        button.setImage(image, for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        button.imageView?.contentMode = .scaleAspectFit
        
        button.addTarget(self, action: #selector(handleFullScreen), for: .touchUpInside)
        
        return button
    }()
    
    let subtitleButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "subtitle")
        button.setImage(image, for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        button.imageView?.contentMode = .scaleAspectFit
        
        button.addTarget(self, action: #selector(handleSubtitle), for: .touchUpInside)
        return button
    }()
    
    let subtitleText : UILabel = {
        
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.backgroundColor = UIColor(white: 0, alpha: 0.65)
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        lb.textColor = .white
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }()
    
    let durationLabel : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    let currentTimeLabel : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    lazy var videoSlider: UISlider = {
        
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor.rgb(red: 22, green: 171, blue: 47, alpha: 1)
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(UIImage(named: "circle"), for: UIControlState())
        
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowControl)))
        
        addSubview(dissmissButton)
        dissmissButton.topAnchor.constraint(equalTo: topAnchor ,constant: 12).isActive = true
        dissmissButton.leftAnchor.constraint(equalTo: leftAnchor ,constant: 8).isActive = true
        dissmissButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dissmissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dissmissButton.alpha = 0
        
        addSubview(fullScreenButton)
        fullScreenButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        fullScreenButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        fullscreenWidth = fullScreenButton.widthAnchor.constraint(equalToConstant: 30)
        fullscreenWidth?.isActive = true
        fullScreenButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        fullScreenButton.alpha = 0
        
        addSubview(subtitleButton)
        subtitleButton.rightAnchor.constraint(equalTo: fullScreenButton.leftAnchor).isActive = true
        subtitleButton.widthAnchor.constraint(equalTo: fullScreenButton.widthAnchor).isActive = true
        subtitleButton.heightAnchor.constraint(equalTo: fullScreenButton.heightAnchor).isActive = true
        subtitleButton.bottomAnchor.constraint(equalTo: fullScreenButton.bottomAnchor).isActive = true
        subtitleButton.alpha = 0
        
        addSubview(durationLabel)
        durationLabel.rightAnchor.constraint(equalTo: subtitleButton.leftAnchor).isActive = true
        durationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        durationLabelWidth = durationLabel.widthAnchor.constraint(equalToConstant: 50)
        durationLabelWidth?.isActive = true
        durationLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        durationLabel.alpha = 0
        
        addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        currentTimeLabelWidth = currentTimeLabel.widthAnchor.constraint(equalToConstant: 50)
        currentTimeLabelWidth?.isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        currentTimeLabel.alpha = 0
        
        addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: durationLabel.leftAnchor, constant: -4).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor, constant: 4).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        videoSlider.alpha = 0
        
        addSubview(subtitleText)
        subtitleTextBottomConstraint = subtitleText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        subtitleTextBottomConstraint?.isActive = true
        subtitleText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subtitleTextWidthConstraint = subtitleText.widthAnchor.constraint(equalToConstant: 0)
        subtitleTextWidthConstraint?.isActive = true
        subtitleTextHeightConstraint = subtitleText.heightAnchor.constraint(equalToConstant: 20)
        subtitleTextHeightConstraint?.isActive = true
        
        addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        pausePlayButton.alpha = 0
        
    }
    
    fileprivate func checkSubtitleAvailable(){
        if video?.subtitleArray == nil {
            subtitleButton.isEnabled = false
        }else{
            subtitleButton.isEnabled = true
        }
    }
    
    fileprivate func setupVideoDuration() {
    
        if video?.hour != nil{
            durationLabelWidth?.constant = 75
            currentTimeLabelWidth?.constant = 75
            currentTimeLabel.text = "00:00:00"
    
        }else{
            durationLabelWidth?.constant = 50
            currentTimeLabelWidth?.constant = 50
            currentTimeLabel.text = "00:00"
        }
        durationLabel.text = video?.setupDuration()
    }
    
    @objc private func handleFullScreen(){
        delegate?.handleFullScreen()
    }
    
    @objc private func handlePausePlay(){
        delegate?.handlePausePlay()
    }
    
    @objc private func handleSubtitle(){
        if subtitleIsShowing {
            subtitleText.isHidden = true
            subtitleButton.tintColor = UIColor.gray
        }else{
            subtitleText.isHidden = false
            subtitleButton.tintColor = .white
        }
        subtitleIsShowing = !subtitleIsShowing
    }
    
    @objc private func handleSliderChange(){
        delegate?.handleSliderChange()
    }
    
    @objc private func handleShowControl() {
        
        subtitleTextBottomConstraint?.constant = -30
        self.fullScreenButton.alpha = 1
        self.subtitleButton.alpha = 1
        self.pausePlayButton.alpha = 1
        self.videoSlider.alpha = 1
        self.durationLabel.alpha = 1
        self.currentTimeLabel.alpha = 1
        self.dissmissButton.alpha = 1
        self.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        tapTimer?.invalidate()
        tapTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(dismissControl), userInfo: nil, repeats: false)
        
    }
    
    @objc private func dismissControl() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            self.videoSlider.alpha = 0
            self.durationLabel.alpha = 0
            self.currentTimeLabel.alpha = 0
            self.pausePlayButton.alpha = 0
            self.fullScreenButton.alpha = 0
            self.subtitleButton.alpha = 0
            self.dissmissButton.alpha = 0
            self.backgroundColor = .clear
            
        }, completion: { (_) in
            self.subtitleTextBottomConstraint?.constant = -8
        })
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

