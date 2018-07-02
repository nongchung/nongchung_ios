//
////
////  MainViewController.swift
////  nongchung_iOS
////
////  Created by 권민하 on 2018. 7. 1..
////  Copyright © 2018년 농활청춘. All rights reserved.
////
//
//import UIKit
//import Alamofire
//import SwiftyJSON
//import Kingfisher
//
////UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
//class MainViewController: UIViewController {
//    @IBOutlet weak var mainTableView: UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //mainTableView.register(FirstTableViewCell.self, forCellReuseIdentifier: "FirstTableViewCell")
//        mainInit()
//    }
//
//    func mainInit() {
//        self.mainTableView.delegate = self
//        self.mainTableView.dataSource = self
//        self.mainTableView.reloadData()
//    }
//
//}
//
//extension MainViewController : UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 9
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let firstCell : FirstTableViewCell = mainTableView.dequeueReusableCell(withIdentifier: "FirstTableViewCell", for: indexPath) as! FirstTableViewCell
//
//            return firstCell
//        } else if indexPath.section == 1 {
//            let cell = UITableViewCell()
//            return cell
//        } else {
//            let cell = UITableViewCell()
//            return cell
//        }
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300
//    }
//
//}
//
