//
//  ContentViewController.swift
//  MusicPlayer
//
//  Created by Ringo on 2017/8/10.
//  Copyright © 2017年 com.omni. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipButton: UIButton!
    var index = 0
    var imageName = ""
    
    @IBAction func skipBtnClick(_ sender: UIButton) {
        
        UserDefaults.standard.setIsFirstLaunch(value: true)
        
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: imageName)
        pageControl.numberOfPages = 4
        pageControl.currentPage = index
        
        skipButton.isHidden = (index != 3)
        pageControl.isHidden = (index == 3)
        
    }


}
