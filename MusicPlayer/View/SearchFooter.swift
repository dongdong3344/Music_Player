//
//  SearchFooter.swift
//  MusicPlayer
//
//  Created by Ringo on 2017/8/13.
//  Copyright © 2017年 com.omni. All rights reserved.
//

import UIKit

class SearchFooter: UIView {
  
    var resultLabel :UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
        
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        configureView()
    }
    
    
    func configureView(){
        backgroundColor = UIColor.candyGreen
        alpha = 0
        resultLabel.frame = self.bounds
        addSubview(resultLabel)
    }
    
    fileprivate func showFooter(){
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
        
    }
    
    fileprivate func hideFooter(){
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        }
        
    }

}

extension SearchFooter{
    
    public func setNotFiltering(){
        resultLabel.text = ""
        hideFooter()
    }
    
    public func setIsFiltering(filteredItemCount: Int, of totalItemCount: Int){
        
        if filteredItemCount == totalItemCount {
            setNotFiltering()
        }else if filteredItemCount == 0{
            resultLabel.text = "没有查询到您想要的结果"
            showFooter()
        }else{
            resultLabel.text = "查询到\(filteredItemCount)条结果"
            showFooter()
        }
        
    }
    
}
