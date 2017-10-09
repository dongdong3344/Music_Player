//
//  APIManager.swift
//  MusicPlayer
//
//  Created by lindongdong on 2017/8/31.
//  Copyright © 2017年 com.omni. All rights reserved.
//

import UIKit
import Alamofire

class APIManager: NSObject {
    
    static let shared = APIManager()
    private override init() {
        
    }
    //RESET API
    let Search_HotTags = "http://mobilecdnbj.kugou.com/api/v3/search/hot"
    let Search_Push = "http://mobilecdnbj.kugou.com/api/v3/search/push"
    let Search_Recommendation = "http://mobilecdnbj.kugou.com/new/app/i/search.php"
    let Search_Results = ""
    
    //获取searchBarPlaceHolder text
    func getSearchPush(completion:@escaping(String) -> Void){
        
        var searchPushs = [String]()
        let parameters:[String:Any] = ["plat":2,"version":8800,"channel":1009]
        let headers = ["Content-Type":"Application/json"]
        
        Alamofire.request(Search_HotTags, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let json = response.result.value as? JSON{
                    if let data = json["data"] as? JSON{
                        if let info = data["info"] as?[JSON]{
                            searchPushs = info.map({
                                return (SearchHotTags.init(json: $0).keyword)!
                            })
                        }
                        completion(self.randomElement(from: searchPushs))
                    }
                }
            case .failure(let error):
                
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    //获取热门搜索标签
    func getSearchHotTags(completion:@escaping([String]) -> Void){
        
        var searchHotTags = [String]()
        let parameters:[String:Any] = ["plat":2,"count":50]
        let headers = ["Content-Type":"Application/json"]
        
        Alamofire.request(Search_HotTags, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let json = response.result.value as? JSON{
                    if let data = json["data"] as? JSON{
                        if let info = data["info"] as?[JSON]{
                            searchHotTags = info.map({
                                return (SearchHotTags.init(json: $0).keyword)!
                            })
                        }
                        completion(searchHotTags)
                    }
                }
            case .failure(let error):
                
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    
    //获取关键字推荐搜索
    func getSearchRecommendation(keyword:String,completion:@escaping([String]) -> Void){
        
        var recommendations = [String]()
        let parameters:[String:Any] = ["cmd":302,"keyword":keyword]
        let headers = ["Content-Type":"Application/json"]
        
        Alamofire.request(Search_Recommendation, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let json = response.result.value as? JSON{
                    if let data = json["data"] as? [JSON]{
                        recommendations = data.map({
                            return (SearchRecommendation.init(json: $0).keyword)!
                        })
                    }
                    completion(recommendations)
                }
            case .failure(let error):
                
                print(error.localizedDescription)
                
            }
        }
         
    }
    
    //从数组中随机取一个元素
    func randomElement<T>(from array: Array<T>) -> T {
        let index: Int = Int(arc4random_uniform(UInt32(array.count)))
        return array[index]
    }
}
