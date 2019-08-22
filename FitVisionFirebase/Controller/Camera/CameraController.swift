//
//  CameraController.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/3/15.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, CameraDelegate,  UIViewControllerTransitioningDelegate{
    
    var accountUserCell: AccountUserCell?
    var isUsingFrontCamera = false
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()

    let cameraPositionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "rotate_camera").withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCameraPosition), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            appDelegate.deviceRotated(isStatusBarHidden: true)
        }
        
        UIApplication.shared.isStatusBarHidden = true
        
        transitioningDelegate = self
        
        setupCaptureSession()
        setupHUD()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            appDelegate.deviceRotated(isStatusBarHidden: false)
        }
        
        UIApplication.shared.isStatusBarHidden = false
    }
    
    let customAnimationPresenter = CustomAnimationPresenter()
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresenter
    }
    
    let customAnimationDismisser = CustomAnimationDismisser()
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismisser
    }
    
    
    fileprivate func setupHUD(){
        
        capturePhotoButton.removeFromSuperview()
        dismissButton.removeFromSuperview()
        cameraPositionButton.removeFromSuperview()
        
        view.addSubview(capturePhotoButton)
        capturePhotoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24).isActive = true
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        capturePhotoButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        capturePhotoButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
  
        view.addSubview(dismissButton)
        dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        dismissButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(cameraPositionButton)
        cameraPositionButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        cameraPositionButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        cameraPositionButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cameraPositionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func handleCapturePhoto(){
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        
        output.capturePhoto(with: settings, delegate: self)
    }
    
    var previewImage: UIImage?
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        print("Finish processing photo sample buffer...")
        
        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
        
        previewImage = UIImage(data: imageData!)
        if isUsingFrontCamera{
            previewImage = UIImage(cgImage: (previewImage?.cgImage!)!, scale: (previewImage?.scale)!, orientation: .leftMirrored)
        }

        
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        containerView.delegate = self

        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        print("finish processing photo smaple buffer")
    }
    
    func didSaveCameraPhoto(image: UIImage) {
        accountUserCell?.handleCameraPhoto(image: image)
    }
    
    var input: AVCaptureInput!
    let output = AVCapturePhotoOutput()
    let captureSession = AVCaptureSession()
    var previewLayer: CALayer?
    
    private func setupCaptureSession(){

        //1.setup input
        var cameraDevice: AVCaptureDevice?
        
        if isUsingFrontCamera{
            guard let captureFrontDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: .video, position: .front) else {
                print("front device error")
                return
            }
            cameraDevice = captureFrontDevice
        }else{
            guard let captureBackDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
                print("back device error")
                return
            }
            cameraDevice = captureBackDevice
        }
        
        do{
            guard let device = cameraDevice else { return }
            input =  try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
            }
        }catch let err{
            print("can not setup camera input", err)
        }
        
        //2.setup outputs
        if captureSession.canAddOutput(output){
            captureSession.addOutput(output)
        }
        
        //3.setup output preview
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        guard let preview = previewLayer else { return }
        preview.frame = view.frame
        view.layer.addSublayer(preview)
        
        captureSession.startRunning()
    }
    
    @objc private func handleCameraPosition(){
        captureSession.stopRunning()
        captureSession.removeInput(input)
        previewLayer?.removeFromSuperlayer()
        
        isUsingFrontCamera = !isUsingFrontCamera
        
        setupCaptureSession()
        setupHUD()
    }
    
    @objc private func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
}
