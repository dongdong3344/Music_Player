//
//  CustomSearchController.swift
//  MusicPlayer
//
//  Created by Ringo on 2017/8/17.
//  Copyright © 2017年 com.omni. All rights reserved.
//

import Foundation
import UIKit

/// 自定义SearchController
class CustomSearchController:UISearchController{
    
    override init(searchResultsController: UIViewController?) {
        
        super.init(searchResultsController: searchResultsController)
        self.definesPresentationContext = true
        self.dimsBackgroundDuringPresentation = false
        self.hidesNavigationBarDuringPresentation = true
        self.searchBar.searchBarStyle = .minimal
       
        self.searchBar.placeholder = "搜索歌单内歌曲"
        self.searchBar.textField?.textColor = UIColor.white
        self.searchBar.placehloderLabel?.textColor = .white
        self.searchBar.placehloderLabel?.font = UIFont.systemFont(ofSize: 15)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //以下code必须有，不然报错
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
}
