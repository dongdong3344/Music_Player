//
//  MusicListViewController.swift
//  MusicPlayer
//
//  Created by lindongdong on 2017/8/31.
//  Copyright © 2017年 com.omni. All rights reserved.
//

import UIKit
import PYSearch

@available(iOS 11.0, *)
class MusicListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating{
   
    @IBOutlet weak var searchFooter: SearchFooter!
    @IBOutlet weak var tableView: UITableView!
    // searchController
    lazy var searchController :CustomSearchController = {
        
        let searchVC  = CustomSearchController(searchResultsController: nil)
        searchVC.searchBar.delegate = self
        searchVC.searchResultsUpdater = self
        
        return searchVC
        
    }()
    var imageArray = [UIImage]()
    var musics = [Music]()
    var filteredMusics = [Music]()
    let identifier = "cellID"
    var hotSearchTags = [String]()
    var searchBarPlaceholder:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        

        getMusics()
        
        setupTableView()
        
        navigationItem.searchController = searchController
       // navigationItem.hidesSearchBarWhenScrolling = true
        
        APIManager.shared.getSearchPush { (searchBarPlaceholder) in
            self.searchBarPlaceholder = " " + searchBarPlaceholder
        }
        
        APIManager.shared.getSearchHotTags { (searchHotTags) in
            self.hotSearchTags = searchHotTags
        }
    

        setupLeftBarItem()
       
     
    }
    
    func setupLeftBarItem(){
        
        for i in 1...6{
            if let image = UIImage(named: "cm2_topbar_icn_playing\(i)") {
                imageArray.append(image)
            }
        }
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.animationImages = imageArray
        imageView.animationDuration = 1.0
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
        let leftBarItem = UIBarButtonItem(customView: imageView)
        navigationItem.leftBarButtonItem = leftBarItem
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        selectRow()
        
        //显示引导页
        
        if UserDefaults().isFirstLaunch() == true  {
            return
        }
        
        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "GuideController") as? GuideViewController {
            present(pageVC, animated: true, completion: nil)
        }
        
        animateTableView()
        
       
    }
    
    @IBAction func searchClick(_ sender: UIBarButtonItem) {
        
        let searchVC = PYSearchViewController(hotSearches: hotSearchTags, searchBarPlaceholder: searchBarPlaceholder) { (searchVC, searchBar, searchText) in
            
            if let keyword = searchText{
                APIManager.shared.getSearchRecommendation(keyword: keyword) { (recommendationrs) in
                    _ = recommendationrs.map({print($0)})
                }
                
            }else{
                APIManager.shared.getSearchRecommendation(keyword: self.searchBarPlaceholder) { (recommendationrs) in
                    _ = recommendationrs.map({print($0)})
                }
            }
        
        }
        
        setupSearch(with: searchVC!)
      
        let nav = UINavigationController.init(rootViewController: searchVC!)
        nav.navigationBar.prefersLargeTitles = false
        present(nav, animated: true, completion: nil)
        

    }
    
    
    func setupSearch(with searchVC:PYSearchViewController){
        
        //searchVC.searchBar.scopeButtonTitles = ["French", "English"]
        searchVC.hotSearchStyle = .arcBorderTag
        searchVC.searchHistoriesCount = 10
        searchVC.emptySearchHistoryLabel.textColor = UIColor.candyGreen
        searchVC.searchBar.textField?.font = UIFont.systemFont(ofSize: 12)
        searchVC.searchBar.textField?.textColor = UIColor.lightGray
        searchVC.searchBar.placehloderLabel?.font = UIFont.systemFont(ofSize: 12)
        
    }
    
    
    func getMusics(){
        musics = MusicPlayManager.shared.musics!
    }
    
    func setupTableView(){
        
        tableView.register(UINib.init(nibName: "MusicCell", bundle: nil), forCellReuseIdentifier: identifier)
        
      //  tableView.backgroundColor = UIColor.clear
        
        tableView.separatorStyle = .none
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            searchFooter.setIsFiltering(filteredItemCount: filteredMusics.count, of: musics.count)
            return filteredMusics.count
        }
        searchFooter.setNotFiltering()
        return musics.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as!MusicCell
        let music:Music
        if isFiltering() {
            music = filteredMusics[indexPath.row]
        }else{
            music = musics[indexPath.row]
        }
        cell.music = music
        cell.numberLabel.text = NSString(format: "%02d", indexPath.row + 1) as String
           // String(indexPath.row + 1)
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.saveIndex(value: indexPath.row)
        let presentVC = MusicPlayerViewController()
        present(presentVC, animated: true) {
            MusicPlayManager.shared.play()
        }
    }
    
    func selectRow(){
        let index  = UserDefaults.standard.getIndex()
        
        tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
    }
    
    func animateTableView(){
        
        // tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for (index, cell) in cells.enumerated() {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
        }
        
    }
   

}
