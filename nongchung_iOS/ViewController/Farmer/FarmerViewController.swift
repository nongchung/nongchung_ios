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
    
    //var farmerIdx: Int?
    var addr: String?
    var farmName: String?
    var farmerName: String?
    var farmerImg: String?
    var fphone: String?
    var comment: String?
    
    let ud = UserDefaults.standard
    
    var nongwhal: [FarmerDataVO] = [FarmerDataVO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        farmerTableView.delegate = self
        farmerTableView.dataSource = self
        
        farmerInit()

    }

    
    func farmerInit() {
        FarmerService.farmerInit(nhIdx: nhIdx!) { (farmerInfoData, farmerData) in
            self.farmerName = farmerInfoData.farmerName
            self.farmName = farmerInfoData.farmName
            self.addr = farmerInfoData.addr
            self.farmerImg = farmerInfoData.farmerImg
            self.fphone = farmerInfoData.fphone
            self.comment = farmerInfoData.comment
            
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
            
            cell.nameLabel.text = "\(gsno(farmName)) 농부"
            cell.titleLabel.text = farmerName
            cell.phoneLabel.text = fphone
            cell.addressLabel.text = addr
            cell.contentLabel.text = comment
            cell.profileImageView.kf.setImage(with: URL(string: gsno(farmerImg)), placeholder: #imageLiteral(resourceName: "main_profile_circle"))
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FarmerTableViewCell", for: indexPath) as! FarmerTableViewCell
            let index = nongwhal[indexPath.row]
            cell.titleLabel.text = index.nhName
            cell.addressLabel.text = index.farmAddr
            cell.priceLabel.text = String("\(gino(index.price))원")
            cell.mainImageView.kf.setImage(with: URL(string: index.farmImg!), placeholder: #imageLiteral(resourceName: "main_image2"))
            
            cell.heartButton.tag = index.nhIdx!
            cell.heartButton.addTarget(self, action: #selector(heartButtonAction), for: .touchUpInside)

            if index.isBooked == nil || index.isBooked == 0{
                cell.heartButton.setImage(#imageLiteral(resourceName: "main_heart_empty"), for: .normal)
            }
            else{
                cell.heartButton.setImage(#imageLiteral(resourceName: "main_heart_fill"), for: .normal)
            }
            
            return cell
        }
    }
    
    //MARK: 좋아요 통신
    @objc func heartButtonAction(_ sender: UIButton) {
        if sender.imageView?.image == #imageLiteral(resourceName: "main_heart_empty") && ud.string(forKey: "token") == nil{
            NotificationCenter.default.post(name: .noLoginUser, object: nil)
        }
        else if sender.imageView?.image == #imageLiteral(resourceName: "main_heart_empty") && ud.string(forKey: "token") != nil{
            HeartService.likeAddNetworking(nhIdx: sender.tag) {
                print("하트 추가 성공")
                sender.setImage(#imageLiteral(resourceName: "main_heart_fill"), for: .normal)
            }
        }
        else{
            HeartService.likeDeleteNetworking(nhIdx: sender.tag) {
                print("하트 삭제 성공")
                sender.setImage(#imageLiteral(resourceName: "main_heart_empty"), for: .normal)
            }
        }
    }
    
    
}
