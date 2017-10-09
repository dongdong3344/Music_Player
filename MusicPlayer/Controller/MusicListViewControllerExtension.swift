//
//  MusicListViewControllerExtension.swift
//  MusicPlayer
//
//  Created by Ringo on 2017/8/16.
//  Copyright © 2017年 com.omni. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 11.0, *)
extension MusicListViewController{

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.searchController.isActive = false
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(self.searchClick(_:)))
            
            self.selectRow()
            
        }
        
    }
    
    func isFiltering() -> Bool{
        
        return searchController.isActive && !searchBarIsEmpty()
        
    }
    
    func searchBarIsEmpty() -> Bool {
        
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterWithSearchText(_ searchText: String) {
        
        filteredMusics = musics.filter({( music : Music) -> Bool in
            
            let text = searchText.lowercased()
            guard let title = music.title?.lowercased() ,let artist = music.artist?.lowercased(),let album = music.album?.lowercased()else {
                return false
            }
            return (title.contains(text) || artist.contains(text)||album.contains(text))
        })
        
        tableView.reloadData()
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterWithSearchText(searchController.searchBar.text!)
    }
    
    
}
