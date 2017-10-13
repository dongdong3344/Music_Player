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
    @IBOutlet weak var containerView: UIView!
    
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
    
    let needleImgView :UIImageView = {
        
        let imgView = UIImageView()
        imgView.image = #imageLiteral(resourceName: "cm2_play_needle_play")
       // imgView.backgroundColor = .yellow
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
        
    }()
    
    // MARK: - IBActions
    @IBAction func setVolume(_ sender: UISlider) {
        
        MusicPlayManager.shared.setVolume(volume: sender.value)
    }
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        
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
        
        if !sender.isSelected {
            rotateNeedleImageView()
            playOrPauseButton.setImage(#imageLiteral(resourceName: "cm2_fm_btn_play"), for: .normal)
            MusicPlayManager.shared.pause()
            stopTimer()
           
            
        }else{
            
            recoverNeedleImageView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.playOrPauseButton.setImage(#imageLiteral(resourceName: "cm2_fm_btn_pause"), for: .normal)
                MusicPlayManager.shared.play()
                self.startTimer()
            })
         
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
    
    // MARK: - Rotate or Recover Needle
    func rotateNeedleImageView(){
        
        setAnchorPoint(CGPoint(x: 25 / 97.0, y:25 / 153.0), for: needleImgView)
        UIView.animate(withDuration: 0.25) {
            self.needleImgView.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi / 5))
            
        }
    }
    
    func recoverNeedleImageView() {
        
        setAnchorPoint(CGPoint(x:25 / 97.0, y:25 / 153.0), for: needleImgView)
        UIView.animate(withDuration: 0.25) {
            self.needleImgView.transform = .identity
        }
       
        
    }
    
    // MARK: - Previous and Next Play Animation
    func setupPreviousPlay(){
    
        setupNeedleAndPlay()
        
        UIView.animate(withDuration: 0.25, animations: {_ in
            self.artworkImageView.center = CGPoint(x: self.artworkImageView.frame.size.width * 0.5 +  UIScreen.main.bounds.size.width, y: self.artworkImageView.center.y)
            self.playDiskImageView.center = CGPoint(x: self.playDiskImageView.frame.size.width * 0.5  + UIScreen.main.bounds.size.width, y: self.playDiskImageView.center.y)
        }) { (finished:Bool) in
            self.artworkImageView.center = self.circleImageView.center
            self.playDiskImageView.center = self.circleImageView.center
        }
        
    }
    
    func setupNextPlay(){
        
        
       setupNeedleAndPlay()
        
        UIView.animate(withDuration: 0.25, animations: { _ in
            
            self.artworkImageView.center = CGPoint(x: -self.artworkImageView.frame.size.width, y: self.artworkImageView.center.y)
            self.playDiskImageView.center = CGPoint(x: -self.playDiskImageView.frame.size.width, y: self.playDiskImageView.center.y)
        }) { (finished:Bool) in
            
            self.artworkImageView.center = self.circleImageView.center
            self.playDiskImageView.center = self.circleImageView.center
        }
        
    }
    
    
    func setupNeedleAndPlay() {
        
        rotateNeedleImageView()
        playOrPauseButton.setImage(#imageLiteral(resourceName: "cm2_fm_btn_play"), for: .normal)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.recoverNeedleImageView()
            self.artworkImageView.transform = .identity
            self.playOrPauseButton.setImage(#imageLiteral(resourceName: "cm2_fm_btn_pause"), for: .normal)
            MusicPlayManager.shared.playNext()
        }
        if !playOrPauseButton.isSelected {
            playOrPauseButton.isSelected = true
            setupDisplayLink()
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
        
        artworkImageView.setAsCircle(borderWidth: 1, borderColor: .black)
        
        addNotifications()
        
        containerView.addSubview(needleImgView)
        
        setupConstrains()
  
        
    }
    
    // 约束条件
    func setupConstrains(){
        
        needleImgView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor,constant: 20).isActive = true

        needleImgView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -28).isActive = true
        needleImgView.widthAnchor.constraint(equalToConstant: 97).isActive = true
        needleImgView.heightAnchor.constraint(equalToConstant: 153).isActive = true
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        stopTimer()
        
        removeHideVolumeSliderTimer()
        
        NotificationManager.shared.removeObserver(self)
    }
    
    // MARK: -  Set AnchorPoint
    func setAnchorPoint(_ anchorPoint:CGPoint, for view:UIView){
        
        let oldOrigin = view.frame.origin;
        view.layer.anchorPoint = anchorPoint;
        let newOrigin = view.frame.origin;
        
        var transition = CGPoint()
        transition.x = newOrigin.x - oldOrigin.x;
        transition.y = newOrigin.y - oldOrigin.y;
        view.center = CGPoint(x: view.center.x - transition.x, y: view.center.y - transition.y)
     
    }

    // MARK: - Add Notifications
    
    func addNotifications() {
        
        NotificationManager.shared.addUpdatePlayerObserver(self, action: #selector(self.updateViews))
        
        NotificationManager.shared.audioSessionRouteChangeObserver(self,  action: #selector(handleRouteChange(_:)))
        
        NotificationManager.shared.audioSessionInterruptionObserver(self, action: #selector(handleInterrupt(_:)))
       
        
    }
    
    func handleRouteChange(_ notification:Notification){
        
        let routeChangeDict = notification.userInfo! as NSDictionary
        
        let routeChangeReason  = routeChangeDict.value(forKey: AVAudioSessionRouteChangeReasonKey) as! UInt
        switch routeChangeReason {
        case AVAudioSessionRouteChangeReason.newDeviceAvailable.rawValue:
            print("插入耳机")
            break
        case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.rawValue:
            print("拔出耳机")
            MusicPlayManager.shared.pause()
            playOrPauseButton.isSelected = false
            playOrPauseButton.setImage(#imageLiteral(resourceName: "cm2_fm_btn_play"), for: .normal)
            break
        default:
            break
        }
        
    }
    
    //处理中断事件
    func handleInterrupt(_ notification:Notification){
        let interruptionDict = notification.userInfo! as NSDictionary
        let interruptionType = interruptionDict.value(forKey: AVAudioSessionInterruptionTypeKey) as? UInt
        let interruptionOption  = interruptionDict.value(forKey: AVAudioSessionInterruptionOptionKey) as? UInt
         // 收到播放中断的通知暂停播放,
        if interruptionType == AVAudioSessionInterruptionType.began.rawValue {
            MusicPlayManager.shared.pause()
       
        }
        // 中断结束，判断是否需要恢复播放
        if interruptionOption == AVAudioSessionInterruptionOptions.shouldResume.rawValue{
            MusicPlayManager.shared.play()
        }
            
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
        
        playOrPauseButton.setImage(#imageLiteral(resourceName: "cm2_fm_btn_pause"), for: .normal)
        
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


