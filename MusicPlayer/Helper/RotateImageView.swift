//
//  RotateImageView.swift
//  MusicPlayer
//
//  Created by Ringo on 2017/8/23.
//  Copyright © 2017年 com.omni. All rights reserved.
//

import UIKit

class RotateImageView: UIImageView,CAAnimationDelegate {
    
     var rotationAnimation:CABasicAnimation!
    
     func rotate360Degree() {
        rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: .pi * 2.0) // 旋转角度
        rotationAnimation.duration = 10 // 旋转周期
        rotationAnimation.isCumulative = true // 旋转累加角度
        rotationAnimation.repeatCount = MAXFLOAT // 旋转次数
        rotationAnimation.autoreverses = false
        layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func pauseRotate(){
        if (layer.animation(forKey: "rotationAnimation") != nil) {
            transform = layer.presentation()!.affineTransform()
            layer.removeAllAnimations()
            rotationAnimation = nil
        }
        
    }
    
    func resumeRotate(){
        if layer.animation(forKey: "rotationAnimation") == nil {
            rotate360Degree()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: .UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        
    }
    
    deinit {
        pauseRotate()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func applicationWillResignActive(){
        
        pauseRotate()
        
    }
    
    @objc func applicationDidBecomeActive(){
        
        resumeRotate()
        
    }
    
    
}
