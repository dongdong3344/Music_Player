//
//  MusicPlayManager.swift
//  MusicPlayer
//
//  Created by Ringo on 2017/8/15.
//  Copyright © 2017年 com.omni. All rights reserved.
//

import UIKit
import AVFoundation

enum MusicPlayMode: String {
    case ListLoop = "list_loop"
    case SingleLoop = "single_loop"
    case Random = "random"
}

class MusicPlayManager: NSObject,AVAudioPlayerDelegate {
    
    static let shared = MusicPlayManager.init()
    
    /// music数组
    var musics : [Music]?
    
    /// 播放器
    var player : AVAudioPlayer!
    /// 当前music index
    var currentIndex:Int = 0
    
    /// 上个播放的music index
    var lastIndex = 0
    
    /// 当前音乐文件URL
    var currentURL: String?{
        get {
            guard let musics = musics, currentIndex < musics.count else{
                return nil
            }
            return musics[currentIndex].muscicURL
        }
    }
    
    private override init() {
        
        super.init()
        
        getMusics()
        
        preparePlayer()
        
        setupPlayBackground()
        
    }
    
   private func getMusics(){
        Music.getMusicList { [unowned self] (musics) in
            self.musics = musics.sorted{$0.title! < $1.title!}
        }
    }
    
    func setupPlayBackground(){
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch let error {
            
            print(error.localizedDescription)
            
            
            
        }
        
    }
    
    func preparePlayer(){
        

        do {
            
            if let url =  URL(string:(musics?[currentIndex].muscicURL)!){
                player = try AVAudioPlayer(contentsOf: url)
                player.volume = 0.5 // default to 0.5
                player.delegate = self
                player.prepareToPlay()
            }
            
            
        } catch let error  {
            print(error.localizedDescription)
        }
        
    }
    
    public func playNext(){
        
        /**We don't want the next music playing if the player is paused. However, this method is also called when a music finishes playing. In that case, we do want to play the next, which is what the parameter musicFinishedPlaying is for.*/
        
        var playerIsPlaying = false
        
        if player.isPlaying {
            player.stop()
            playerIsPlaying = true
        }
        
        currentIndex += 1
        
        if currentIndex > (musics?.count)! - 1 {
            currentIndex = 0
        }
        
        UserDefaults.standard.saveIndex(value: currentIndex)
        
        play()
    }
    
     public func playPrevious(){
        
        currentIndex -= 1
        
        if currentIndex < 0 {
            currentIndex = (musics?.count)! - 1
        }
        
        UserDefaults.standard.saveIndex(value: currentIndex)
        
        play()
        
    }
    
    func playNextWhenFinished() {
        let currentMode = currentPlayMode()
        
        if currentMode == .Random {
            
            currentIndex = Int(arc4random_uniform(UInt32(musics!.count)))
            
            print("currentIndex:\(currentIndex)")
            
            UserDefaults.standard.saveIndex(value: currentIndex)
            
            play()
            
        }else if currentMode == .ListLoop {
            playNext()
            
        }else {
            play()
        }
        
    }
    
}

extension MusicPlayManager {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
       
        if flag == true {
          playNextWhenFinished()
        }
    }
    
    func setVolume(volume:Float){

        player.volume = volume
    }
    
    func getProgressValue()->Float{
        
         let currentTime = player.currentTime
         let duration = player.duration
        return Float(currentTime / duration)
    }
    
    func getDurationAsString() -> String{
        
         let time = player.duration
        
         return getTimeString(from: time)
    }
    
    
    func getCurrentTimeAsString() -> String{
        
        let time = player.currentTime
        
        return getTimeString(from: time)
    }
    
    
   private func getTimeString(from duration:Double) -> String{
        
        let hours   = Int(duration / 3600)
        let minutes = Int(duration / 60) % 60
        // truncatingRemainder方法进行浮点数取余
        let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%:%02i:%02i", arguments: [hours,minutes,seconds])
        }else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
        
    }
    
    func play() {
        
        currentIndex = UserDefaults.standard.getIndex()
        
        if currentIndex != lastIndex{
            preparePlayer()
            player.play()
            
        }
        
        if !player.isPlaying && currentIndex == lastIndex  {
            
            player.play()
            
        }
        
        NotificationManager.sharedInstance.postUpdatePlayerNotification()
        
        lastIndex = currentIndex
        
    }
    func pause(){
        
        if player.isPlaying{
            player.pause()
        }
    }
    
    func stop(){
        if player.isPlaying{
            player.stop()
            player.currentTime = 0
        }
    }
    
    
    func currentPlayMode() -> MusicPlayMode {
        
        if let mode = UserDefaults.standard.playerPlayMode() {
            switch mode {
            case MusicPlayMode.ListLoop.rawValue:
                return.ListLoop
            case MusicPlayMode.SingleLoop.rawValue:
                return .SingleLoop
            case MusicPlayMode.Random.rawValue:
                return .Random
            default:
                break
            }
        }
        return .ListLoop
    }
    
    func changePlayMode() -> MusicPlayMode {
        var newMode: MusicPlayMode = .ListLoop
        if let mode = UserDefaults.standard.playerPlayMode() {
            switch mode {
            case MusicPlayMode.ListLoop.rawValue:
                newMode = .SingleLoop
            case MusicPlayMode.SingleLoop.rawValue:
                newMode = .Random
            case MusicPlayMode.Random.rawValue:
                newMode = .ListLoop
            default:
                break
            }
        }
        UserDefaults.standard.changePlayerPlayMode(newMode.rawValue)
        
        return newMode
    }   
}




