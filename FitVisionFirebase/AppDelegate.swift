//
//  AppDelegate.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    var statusBarIsHidden: Bool = false
    var statusBarBackgroundView = UIView()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = CustomTabBarController()
        
        attemptRegisterForNotification(application: application)
        
        UINavigationBar.appearance().barTintColor = UIColor.mainGreen
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        UINavigationBar.appearance().isTranslucent = false

        application.statusBarStyle = .lightContent
        
        statusBarBackgroundView.backgroundColor = UIColor.mainGreen
        
        window?.addSubview(statusBarBackgroundView)
        window?.addConstraintsWithFormat(format: "H:|[v0]|", views: statusBarBackgroundView)
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436{
            window?.addConstraintsWithFormat(format: "V:|[v0(44)]", views: statusBarBackgroundView)
        }else{
            window?.addConstraintsWithFormat(format: "V:|[v0(20)]", views: statusBarBackgroundView)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("deviceToken: ", deviceToken)
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Registered with FCM with token:", fcmToken)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //show notification while app is in foreground
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        if let videoId = userInfo["videoId"] as? String{
            
            if let mainTabBarController = window?.rootViewController as? CustomTabBarController{
                mainTabBarController.selectedIndex = 0
                
                if let homeNavigationController = mainTabBarController.viewControllers?.first as? UINavigationController{
                    guard let homeController = homeNavigationController.viewControllers.first as? HomeController else { return }
                    homeController.playVideoWithNotification(videoId: videoId)
                }
            }
        }
        
    }
    
    private func attemptRegisterForNotification(application: UIApplication){
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
                
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, err) in
            if let err = err{
                print("failed to request auth: ",err)
                return
            }
            if granted{
                print("Auth granted")
            }else{
                print("Auth denied")
            }
        }
        
        application.registerForRemoteNotifications()
        
    }
    
    func deviceRotated(isStatusBarHidden: Bool) {
        statusBarIsHidden = isStatusBarHidden
        
        if !isStatusBarHidden{
            statusBarBackgroundView.backgroundColor = UIColor.mainGreen
        }else{
            statusBarBackgroundView.backgroundColor = .clear
        }
    }
    
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

