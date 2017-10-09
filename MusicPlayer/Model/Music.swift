//
//  Music.swift
//  MusicPlayer
//
//  Created by Ringo on 2017/8/5.
//  Copyright © 2017年 com.omni. All rights reserved.
//
import Foundation
import UIKit
import AVFoundation

struct Music {
    var artwork   : UIImage?  //音乐图片
    var title     : String?   //歌曲名称
    var artist    : String?   //歌手名称
    var album     : String?   //专辑名称
    var muscicURL : String?   //文件路径
    
    init(artwork:UIImage,title:String,artist:String,album:String,muscicURL:String) {
        self.artwork = artwork
        self.title = title
        self.artist = artist
        self.album = album
        self.muscicURL = muscicURL
        
    }
    
    
static func getMusicList(completion:@escaping ([Music]) -> Void){
    
    var musicImage  : UIImage?
    var musicTitle  : String?
    var musicArtist : String?
    var musicAlbum  : String?
    var musicURL    : String!
    
    var musics = [Music]()
    
    let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
    
    do {
        let songPaths = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        
        _ = songPaths.map({
            let songPath = $0.absoluteString
            if songPath.contains(".mp3"){
          
                musicURL = songPath
                let mp3Asset = AVURLAsset.init(url: URL(string:songPath)!)
                
                for metadataFormat in mp3Asset.availableMetadataFormats {
                    
                    // func metadata(forFormat format: AVMetadataFormat) -> [AVMetadataItem]
                    for metadataItem in mp3Asset.metadata(forFormat: metadataFormat){
                        
                        if metadataItem.commonKey == "artwork",let imageData  = metadataItem.value as? Data{
                            
                            musicImage = UIImage.init(data: imageData)!
                            
                        }else if metadataItem.commonKey == "title",let title = metadataItem.value as? String {
                            
                            musicTitle = title
                            
                        }else if metadataItem.commonKey == "artist",let artist = metadataItem.value as? String {
                            
                            musicArtist = artist
                            
                        }else if metadataItem.commonKey == "albumName",let album = metadataItem.value as? String {
                            
                            musicAlbum = album
                        }
                        
                    }
                    
                }
                let music = Music(artwork: musicImage!, title: musicTitle!, artist: musicArtist!, album: musicAlbum!,muscicURL:musicURL!)
                musics.append(music)
                
            }
        })
        completion(musics)
       // print(musics)
        
    } catch let error {
        print(error.localizedDescription)
        
    }
 }
    
}
