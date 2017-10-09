//
//  MusicPlayerControllerExtension.swift
//  MusicPlayer
//
//  Created by Ringo on 2017/8/19.
//  Copyright © 2017年 com.omni. All rights reserved.
//

import Foundation
import UIKit
import Toast

extension MusicPlayerViewController{
    
    // MARK: Volume Slider
    
    func setupVolumeSlider(){
        
        volumeSlider.isHidden = true
        
        volumeSlider.addTarget(self, action: #selector(sliderTouchUp), for: .touchUpInside)
        
        volumeSlider.addTarget(self, action: #selector(sliderTouchDown), for: .touchDown)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showVolumeSlider))
        
        view.addGestureRecognizer(tap)
        
    }
    
    /** slider 经历的三个过程
     1. touch down
     
     2. value change
     
     3. touch up inside or touch up outside*/
    
    func sliderTouchUp(){
        
        addHideVolumeSliderTimer()
        
    }
    
    func sliderTouchDown(){
        
        removeHideVolumeSliderTimer()
        
    }
    
    func showVolumeSlider(){
        
        volumeSlider.isHidden = false
        
        addHideVolumeSliderTimer()
        
    }
    
    func addHideVolumeSliderTimer(){
        
        hideVolumeSliderTimer = Timer.init(timeInterval: 3, target: self, selector: #selector(hideVolumeSlider), userInfo: nil, repeats: false)
        
        RunLoop.current.add(hideVolumeSliderTimer, forMode: .defaultRunLoopMode)
    }
    
    func removeHideVolumeSliderTimer(){
        
        if hideVolumeSliderTimer != nil {
            hideVolumeSliderTimer.invalidate()
            hideVolumeSliderTimer = nil
        }
        
    }
    
    func hideVolumeSlider(){
        
        self.volumeSlider.isHidden = true
        
    }
    
    // MARK:Time Slider
    func setupTimeSlider (){
        
        timeSlider.addTarget(self, action: #selector(handleValueChanged), for: .valueChanged)
        
        timeSlider.addTarget(self, action:  #selector(removeSliderTimeLabel), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        
        timeSlider.addGestureRecognizer(tapGesture)
        
        
    }
    

    func handleValueChanged(){
        
        guard let player = MusicPlayManager.shared.player else {return}
        
        player.currentTime = TimeInterval(timeSlider.value) * player.duration
        
        sliderTimeLabel.frame = CGRect(x: timeSlider.thumbCenterX - 25, y: timeSlider.frame.origin.y - 35, width: 50, height: 25)
        sliderTimeLabel.text = currentTimeLabel.text
        
        view.addSubview(sliderTimeLabel)
        
        guard player.isPlaying else {
            player.pause()
            return
        }
        
        player.play(atTime: player.currentTime)
        
    }
    
    
    func handleTap(recognizer:UITapGestureRecognizer){
        
        let touchPoint :CGPoint = recognizer.location(in: timeSlider)
        
        let value = touchPoint.x / timeSlider.frame.size.width
        timeSlider.setValue(Float(value), animated: true)
        
        handleValueChanged()
        
    }
    
    func removeSliderTimeLabel(){
        
        sliderTimeLabel.removeFromSuperview()
    }
    
    // MARK:BlurEffectView
    func setupBlurEffect(){
        
        let effct = UIBlurEffect(style: .regular)
        let effcetView = UIVisualEffectView(effect: effct)
        // effcetView.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        
        effcetView.frame = UIScreen.main.bounds
        bgImageView.addSubview(effcetView)
        
    }
    
    // MARK:Rotate Image
    func rotate360Degree(){
        
        // angle = 1/60秒 * 45°（旋转一周需要8s）
        // 转动的角度 = 时间 * 速度
        
        let angle =  CGFloat(displayLink.duration * Double.pi / 4)
        
        artworkImageView.transform = artworkImageView.transform.rotated(by: angle)
        
    }
    
    // MARK:loopButton click
    func loopButtonClicked(){
        
        var imageName: String
        var showText: String
        let newMode = MusicPlayManager.shared.changePlayMode()
        switch newMode {
        case .ListLoop:
            imageName = "cm2_icn_loop_prs"
            showText = "列表循环"
        case .SingleLoop:
            imageName = "cm2_icn_order_prs-1"
            showText = "单曲循环"
        case .Random:
            imageName = "cm2_icn_shuffle_prs"
            showText = "随机播放"
        }
        loopButton.setImage(UIImage(named: imageName), for: UIControlState())
        
        view.makeToast(showText, duration: 1.5, position: "CSToastPositionCenter", style: CSToastStyle.init(defaultStyle: ()))
        
        
    }
    
    func setupPlayMode() {
        
        var imageName: String
        
        let currentMode = MusicPlayManager.shared.currentPlayMode()
        switch currentMode {
        case .ListLoop:
            imageName = "cm2_icn_loop_prs"
            
        case .SingleLoop:
            imageName = "cm2_icn_order_prs-1"
            
        case .Random:
            imageName = "cm2_icn_shuffle_prs"
            
        }
        loopButton.setImage(UIImage(named: imageName), for: UIControlState())
        
    }
    
}


