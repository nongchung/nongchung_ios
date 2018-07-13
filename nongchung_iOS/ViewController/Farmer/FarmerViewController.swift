//
//  FarmerViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 12..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class FarmerViewController: UIViewController {
    @IBOutlet weak var farmerTableView: UITableView!
    
    var nhIdx: Int?
    
        var farmName: String?
        var farmAddr: String?
        var farmerName: String?
        var phone: String?
        var comment: String?
        var farmerImg: String?
    
    let ud = UserDefaults.standard
    
    var nongwhal: [FarmerDataVO] = [FarmerDataVO]()

    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        farmerTableView.delegate = self
        farmerTableView.dataSource = self
        farmerTableView.tableFooterView = UIView(frame: CGRect.zero)
        farmerTableView.tableHeaderView = UIView(frame: CGRect.zero)
        farmerTableView.separatorInset = UIEdgeInsets(top: 0, left: self.view.frame.width, bottom: 0, right: 0)
        
        farmerInit()
        
    }
    
    
    func farmerInit() {
        FarmerService.farmerInit(nhIdx: nhIdx!) { (farmerInfoData, farmerData) in
                        self.farmName = farmerInfoData.farmName
                        self.farmAddr = farmerInfoData.farmAddr
                        self.comment = farmerInfoData.farmerComment
                        self.farmerName = farmerInfoData.farmerName
                        self.phone = farmerInfoData.farmerPhone
                        self.farmerImg = farmerInfoData.farmerImg

            self.nongwhal = farmerData
            
            self.farmerTableView.reloadData()
        }
    }
    
}

extension FarmerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return nongwhal.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FarmerHeaderTableViewCell", for: indexPath) as! FarmerHeaderTableViewCell
            
            cell.nameLabel.text = "\(gsno(farmerName)) 농부"
            cell.titleLabel.text = farmName
            cell.phoneLabel.text = phone
            cell.addressLabel.text = farmAddr
            cell.contentLabel.text = comment
            cell.profileImageView.imageFromUrl(gsno(farmerImg), defaultImgPath: "intro_profile_circle")
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FarmerTableViewCell", for: indexPath) as! FarmerTableViewCell
            
            let index = nongwhal[indexPath.row]
            
            cell.titleLabel.text = "\(gsno(index.nhName)) \(gsno(index.period))"
            cell.addressLabel.text = farmAddr
            cell.priceLabel.text = String("\(gino(index.price))원")
            cell.mainImageView.imageFromUrl(gsno(index.farmImg), defaultImgPath: "intro_image1")
            
            return cell
        }
    }
}
