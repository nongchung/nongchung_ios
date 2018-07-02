//
//  MainViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mainTableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdTableViewCell", for: indexPath) as! AdTableViewCell
            cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopularListTableViewCell", for: indexPath) as! PopularListTableViewCell
            cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewTableViewCell", for: indexPath) as! NewTableViewCell
            cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeTableViewCell", for: indexPath) as! ThemeTableViewCell
            cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopFarmTableViewCell", for: indexPath) as! PopFarmTableViewCell
            cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
            return cell
        }
    }
    
    // 오토레이아웃이 안들어서 임의로 씀
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 220
        } else if indexPath.section == 1 {
            return 250
        } else if indexPath.section == 2 {
            return 300
        } else if indexPath.section == 3 {
            return 300
        } else {
            return 300
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        mainTableView.rowHeight = UITableViewAutomaticDimension
        mainTableView.estimatedRowHeight = 380
        
        mainTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainTableView.reloadData()
    }
    
    //    func mainInit() {
    //        mainTableView.reloadData()
    //
    //    }
    
}





