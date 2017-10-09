//
//  GuideViewController.swift
//  MusicPlayer
//
//  Created by Ringo on 2017/8/10.
//  Copyright © 2017年 com.omni. All rights reserved.
//

import UIKit

class GuideViewController: UIPageViewController,UIPageViewControllerDataSource {
    
    var images = ["cm2_shareapp_pic1","cm2_shareapp_pic2","cm2_shareapp_pic3","cm2_shareapp_pic4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        if let startVC = getController(withIndex: 0) {
            setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
        }
   
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //获取当前控制器的index
        var index  = (viewController as! ContentViewController).index
        index -= 1
        
        return getController(withIndex: index)
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index  = (viewController as! ContentViewController).index
        index += 1
        
        return getController(withIndex: index)
        
    }
    
    func getController(withIndex index:Int) -> ContentViewController?{
        
        if case 0..<images.count = index{
            if let contentVC = storyboard?.instantiateViewController(withIdentifier: "ContentController") as? ContentViewController{
       
                contentVC.imageName = images[index]
                contentVC.index = index
                return contentVC
            }
            
        }
        
        return nil
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    

}
