//
//  Extension+Tool.swift
//  MusicPlayer
//
//  Created by Ringo on 2017/7/24.
//  Copyright © 2017年 com.omni. All rights reserved.
//


import UIKit

extension UISearchBar{
    var textField: UITextField?{
        if let textField = self.value(forKey: "searchField") as? UITextField {
            
           return textField
        }
        return nil
    }
    
    var placehloderLabel:UILabel?{
       
        if let placeholderLabel = textField?.value(forKey: "placeholderLabel") as? UILabel{
            return placeholderLabel
    }
        return nil
    }
}

extension UIView {
    @discardableResult  //silence the warnings,if the result will not used
    
    public func setAsCircle(borderWidth:CGFloat,borderColor:UIColor?) -> Self {
        self.clipsToBounds = true
        let frameSize = self.frame.size
        self.layer.cornerRadius = min(frameSize.width, frameSize.height) / 2.0
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor

        return self
    }
}


extension UIColor {
    //convenience,用来进行方便的初始化,相当于构造函数重载
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    static let candyGreen = UIColor(red: 67.0/255.0, green: 205.0/255.0, blue: 135.0/255.0, alpha: 1.0)
    
}


