//
//  Search.swift
//  MusicPlayer
//
//  Created by lindongdong on 2017/8/31.
//  Copyright © 2017年 com.omni. All rights reserved.
//

import UIKit

typealias JSON = [String:Any]

class Search: NSObject {
    
    init(json:JSON) {
        super.init()
        setValuesForKeys(json)
    }

    override func setValue(_ value: Any?, forKey key: String) {
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}

//热门搜索标签
class SearchHotTags: Search {
    
    var keyword:String?
}

//搜索推荐
class SearchRecommendation: Search {
    
    var keyword:String?
}

//Placeholder
class SearchPush: Search {
    
    var keyword:String?
}






