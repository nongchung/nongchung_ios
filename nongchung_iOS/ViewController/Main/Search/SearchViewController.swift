//
//  SearchViewController.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 2..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class SearchViewController : UIViewController{
    
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var filteredData = [String]()
    var originalData = ["1","2","3"]
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBar.delegate = self
        searchBar.placeholder = "농장 이름 및 지역명 입력"
        
    }
    
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    //MARK: TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredData.count
        }
        return originalData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            return UITableViewCell()
        }
        else if indexPath.section == 1{
            return UITableViewCell()
        }
        else if indexPath.section == 2{
            
        }
        return UITableViewCell()
    }
    
    //MARK: Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            
            view.endEditing(true)
            
            searchTableView.reloadData()
            
        } else {
            
            inSearchMode = true
            
            filteredData = originalData.filter({$0 == searchBar.text})
            
            searchTableView.reloadData()
        }
    }
    
    
}
