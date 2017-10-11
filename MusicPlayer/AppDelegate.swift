//
//  AppDelegate.swift
//  MusicPlayer
//
//  Created by ringo  on 2017/10/9.
//  Copyright © 2017年 Ringo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
        // 启动图片延时: 1秒
        Thread.sleep(forTimeInterval: 1)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        UINavigationBar.appearance().barTintColor = UIColor(r: 227, g: 0, b: 24)
        UINavigationBar.appearance().tintColor =  .white
       // UINavigationBar.appearance().setBackgroundImage(UIImage(),for: .default)
        
        UINavigationBar.appearance().shadowImage = UIImage()
        
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().prefersLargeTitles = true
            let font = UIFont.init(name: "Pacifico-Regular", size: 40)!
            UINavigationBar.appearance().largeTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName:font]
        } else {
            // Fallback on earlier versions
        }
        
        setupSearchBar()
        
        return true
    }
    
    func imageWithColor(_ color:UIColor,size:CGSize) -> UIImage{
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        if let context  = UIGraphicsGetCurrentContext(){
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
    
    func setupSearchBar(){
        
        if #available(iOS 11.0, *) {
            //设置文字
            UISearchBar.appearance().tintColor = UIColor.black
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 11.0, *) {
            
            // Search bar placeholder text color
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "搜索歌单内的歌曲", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            
            // Search bar text color
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            
            // Insertion cursor color
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.white
            
        } else {
            // Fallback on earlier versions
        }
        
        // Search bar clear icon
        //  UISearchBar.appearance().setImage(UIImage(named: "clear"), for: .clear, state: .normal)
        
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
        
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

