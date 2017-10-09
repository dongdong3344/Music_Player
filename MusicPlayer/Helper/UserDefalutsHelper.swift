//
//  UserDefalutsHelper.swift
//  MusicPlayer
//
//  Created by Ringo on 2017/8/16.
//  Copyright © 2017年 com.omni. All rights reserved.
//

import Foundation

extension UserDefaults{
    
     // 枚举
    enum UserDefaultsKeys : String {
            case isFirstLaunch
            case currentIndex
        }
        
    //设置第一次运行
    func setIsFirstLaunch(value:Bool) {
            set(value, forKey: UserDefaultsKeys.isFirstLaunch.rawValue)//rawValue 字符串值
            synchronize()
            
        }
        
    // 获取是否是第一次运行
    func isFirstLaunch() -> Bool {
            return bool(forKey: UserDefaultsKeys.isFirstLaunch.rawValue)
        }
    
    
    //保存当前Index
    func saveIndex(value:Int) {
        
        set(value, forKey: UserDefaultsKeys.currentIndex.rawValue)
        synchronize()
        
    }
    
    // 获取Index
    func getIndex() -> Int{
        guard let index  = object(forKey: UserDefaultsKeys.currentIndex.rawValue)as? Int else{
            return 0
        }
        return index
    }
    
    // 修改播放模式
    func changePlayerPlayMode(_ mode: String) {
        set(mode, forKey: "Play_Mode")
    }
    
    // 获取当前播放模式
    func playerPlayMode() -> String? {
        if let mode = object(forKey: "Play_Mode") {
            return mode as? String
        }else {
            return nil
        }
    }
    
}
