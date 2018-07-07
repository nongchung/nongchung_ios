//
//  InformationTableViewController.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 4..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import GoogleMaps
import SJSegmentedScrollView

class InformationTableViewController : UIViewController {
    
    @IBOutlet var customTableView: UITableView!
    
    var nhInfoData : NhInfoVO?
    var friendsInfoData : [FriendsInfoVO]?
    var farmerInfoData : FarmerInfoVO?
    var scheduleData : [ScheduleVO]?
    var nearestStartDateData : String?
    var allStartDateData : [AllStartDateVO]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTableView.delegate = self
        customTableView.dataSource = self
        customTableView.separatorInset = UIEdgeInsets(top: 0, left: self.customTableView.frame.width, bottom: 0, right: 0)
        
    }
}

extension InformationTableViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntroduceCell", for: indexPath) as! IntroduceCell
            cell.farmAddressLabel.text = nhInfoData?.addr
            cell.experienceNameLabel.text = nhInfoData?.name
            cell.introduceLabel.text = nhInfoData?.description
            cell.priceLabel.text = "\((nhInfoData?.price)!)원"
            cell.periodLabel.text = nhInfoData?.period
            return cell
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "VolunteerCell", for: indexPath) as! VolunteerCell
            cell.volunteerImageData = friendsInfoData
            cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FarmerCell", for: indexPath) as! FarmerCell
            cell.farmerImageView.imageFromUrl(farmerInfoData?.img, defaultImgPath: "")
            cell.farmerNameLabel.text = farmerInfoData?.name
            cell.introduceLabel.text = farmerInfoData?.comment
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleCell
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SuppliesCell", for: indexPath) as! SuppliesCell
            
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as! MapCell
            cell.addressLabel.text = "잠실종합경기운동장 2번출구"
            cell.awakeFromNib()
            
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PolicyCell", for: indexPath) as! PolicyCell
            
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
            
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension InformationTableViewController: SJSegmentedViewControllerViewSource {
    
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        //Scrollview in child controllers
        return customTableView
    }
}

