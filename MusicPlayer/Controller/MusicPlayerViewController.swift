//
//  MusicPlayerViewController.swift
//  MusicPlayer
//
//  Created by Ringo on 2017/7/20.
//  Copyright © 2017年 com.omni. All rights reserved.
//

import UIKit
import AVFoundation

class MusicPlayerViewController: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var volumeSlider: CustomSlider!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var timeSlider: CustomSlider!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var playOrPauseButton: UIButton!
    @IBOutlet weak var loopButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playDiskImageView: UIImageView!
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    var timer : Timer!
    var hideVolumeSliderTimer : Timer!
    var displayLink:CADisplayLink!
    
    /// 拖拉slider时显示的时间label
    lazy var sliderTimeLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(r: 249, g: 204, b: 226)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
        
    }()
    
    // MARK: - IBActions
    @IBAction func setVolume(_ sender: UISlider) {
        
        MusicPlayManager.shared.setVolume(volume: sender.value)
    }
    
    @IBAction func dropButtonClick(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: { success in
            self.dismiss(animated: false, completion: nil)
        })
        
    }
    
    @IBAction func loopButtonClick(_ sender: UIButton) {
        
        loopButtonClicked()
        
    }
    @IBAction func playOrPauseClick(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        setupDisplayLink()
        
        if !playOrPauseButton.isSelected {
            
            playOrPauseButton.setImage(#imageLiteral(resourceName: "cm2_vehicle_btn_play_prs"), for: .normal)
            MusicPlayManager.shared.pause()
            stopTimer()
            
        }else{
            playOrPauseButton.setImage(#imageLiteral(resourceName: "cm2_vehicle_btn_pause_prs"), for: .normal)
            MusicPlayManager.shared.play()
            startTimer()
            
        }
        
    }
    
    @IBAction func audioListClick(_ sender: UIButton) {
        
       
        
    }
    

    @IBAction func playNext(_ sender: UIButton) {
        
        setupNextPlay()
        
    }
    
    @IBAction func playPrevious(_ sender: UIButton) {
        
        setupPreviousPlay()
        
    }
    
    // MARK: - Previous and Next Play Animation
    func setupPreviousPlay(){
        
       MusicPlayManager.shared.playPrevious()
        // 播放下一首或上一首时，图片回到初始位置
       artworkImageView.transform = .identity
        //当前按钮是暂停状态则修改为开始状态，再设置定时器状态
        if !playOrPauseButton.isSelected {
            playOrPauseButton.isSelected = true
            setupDisplayLink()
        }
        
        UIView.animate(withDuration: 0.25, animations: {[unowned self] in
            self.artworkImageView.center = CGPoint(x: self.artworkImageView.frame.size.width * 0.5 +  UIScreen.main.bounds.size.width, y: self.artworkImageView.center.y)
            self.playDiskImageView.center = CGPoint(x: self.playDiskImageView.frame.size.width * 0.5  + UIScreen.main.bounds.size.width, y: self.playDiskImageView.center.y)
        }) { [unowned self] (finished:Bool) in
            self.artworkImageView.center = self.circleImageView.center
            self.playDiskImageView.center = self.circleImageView.center
        }
        
    }
    
    func setupNextPlay(){
        
        MusicPlayManager.shared.playNext()
        
        artworkImageView.transform = .identity
        
        if !playOrPauseButton.isSelected {
             playOrPauseButton.isSelected = true
            setupDisplayLink()
        }
        
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            
            self.artworkImageView.center = CGPoint(x: -self.artworkImageView.frame.size.width, y: self.artworkImageView.center.y)
            self.playDiskImageView.center = CGPoint(x: -self.playDiskImageView.frame.size.width, y: self.playDiskImageView.center.y)
        }) { [unowned self] (finished:Bool) in
            
            self.artworkImageView.center = self.circleImageView.center
            self.playDiskImageView.center = self.circleImageView.center
        }
        
    }
    
    
    // MARK: - DisplayLink
    func setupDisplayLink(){
        
        if playOrPauseButton.isSelected {
            displayLink = CADisplayLink(target: self, selector: #selector(rotate360Degree))
            displayLink.add(to: .current, forMode: .commonModes)
        }else{
            
            displayLink.invalidate()
            displayLink = nil
        }
        
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVolumeSlider()
        
        setupBlurEffect()
        
        setupTimeSlider()
        
        setupPlayMode()
        
        playOrPauseButton.isSelected = true
        
        setupDisplayLink()
        
        artworkImageView.setAsCircle(borderWidth: 5, borderColor: .black)
        
        labelStackView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
       NotificationManager.sharedInstance.addUpdatePlayerObserver(self, action: #selector(self.updateViews))
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    
        UIView.animate(withDuration: 0.5) {
            
             self.labelStackView.transform = .identity
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        stopTimer()
        
        removeHideVolumeSliderTimer()
        
        NotificationManager.sharedInstance.removeObserver(self)
    }
    
    // MARK: - Update Views
    func updateViews(){
        
        setupPlayerUI()
        
        startTimer()
        
    }
    
    func setupPlayerUI(){
        
        let index = UserDefaults.standard.getIndex()
        
        guard let musics = MusicPlayManager.shared.musics else {
            return
        }
        
        artworkImageView.image = musics[index].artwork!
        bgImageView.image = musics[index].artwork!
        titleLabel.text = musics[index].title!
        artistLabel.text = musics[index].artist!

        totalTimeLabel.text = MusicPlayManager.shared.getDurationAsString()
        
        playOrPauseButton.setImage(#imageLiteral(resourceName: "cm2_vehicle_btn_pause_prs"), for: .normal)
        
    }
    // MARK: - Timer
    func startTimer(){
        
       timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {[unowned self] (timer:Timer) in
                self.updateUIWithTimer()
            })
            
    }
    
    func stopTimer(){
        
        timer.invalidate()
        
        
    }
    
    func updateUIWithTimer(){
        
        
        DispatchQueue.main.async {
            
            self.currentTimeLabel.text = MusicPlayManager.shared.getCurrentTimeAsString()
            
            self.timeSlider.value = MusicPlayManager.shared.getProgressValue()
            
        }
        
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: "MusicPlayerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
}


