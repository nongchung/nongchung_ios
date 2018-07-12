//
//  MyActivityViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 6..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher



class MyActivityViewController: UIViewController {
    @IBOutlet weak var myActivityTableView: UITableView!
    
    var activityTotal: [MyActivityTotal] = [MyActivityTotal]()
    var activitys: [MyActivity] = [MyActivity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        myActivityTableView.delegate = self
        myActivityTableView.dataSource = self
        
        myActivityTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.myActivityTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myActivityInit()
    }
    
    func myActivityInit() {
        MyActivityService.myActivityInit { (myActivityTotal, myActivity)  in
            self.activityTotal = myActivityTotal
            self.activitys = myActivity
            
            self.myActivityTableView.reloadData()
        }
        
    }
    
}

extension MyActivityViewController: UITableViewDelegate, UITableViewDataSource, MyActivityViewCellDelegate {
    
    func myActivityTableViewReviewButton(_ sender: MyActivityTableViewCell) {
        guard let tappedIndexPath = myActivityTableView.indexPath(for: sender) else { return }
        
        guard let reviewWriteVC = self.storyboard?.instantiateViewController(
            withIdentifier : "ReviewWriteViewController"
            ) as? ReviewWriteViewController
            else{ return }
        
        reviewWriteVC.reviewTitle = activitys[tappedIndexPath.row].name
        reviewWriteVC.startDate = activitys[tappedIndexPath.row].startDate
        reviewWriteVC.endDate = activitys[tappedIndexPath.row].endDate
        reviewWriteVC.period = activitys[tappedIndexPath.row].period
        reviewWriteVC.idx = activitys[tappedIndexPath.row].idx
        
        self.navigationController?.pushViewController(reviewWriteVC, animated: true)
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return activityTotal.count
        } else {
            return activitys.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyActivityHeaderTableViewCell", for: indexPath) as! MyActivityHeaderTableViewCell
            
            let activityTotalRow = activityTotal[indexPath.row]
            
            //            if let ttime = activityTotalRow.ttime {
            //                cell.timeLabel.text = "\(ttime)"
            //            }
            cell.timeLabel.text = "\(activityTotalRow.ttime ?? 0)"
            cell.countLabel.text = "\(activityTotalRow.tcount ?? 0)"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyActivityTableViewCell", for: indexPath) as! MyActivityTableViewCell
            
            let activityRow = activitys[indexPath.row]
            
            // 신청중인 농활
            if activityRow.state == 0 {
                cell.reviewView.isHidden = true
                cell.progressView.isHidden = false
                cell.stateImageView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.mainImageView.kf.setImage(with: URL(string: gsno(activityRow.img)), placeholder: UIImage(named: "woman_select"))
                cell.countLabel.text = "\(indexPath.row + 1)"
                cell.titleLabel.text = activityRow.name
                cell.addressLabel.text = activityRow.addr
                cell.priceLabel.text = "\(activityRow.price)"
                cell.startDate.text = activityRow.startDate
                cell.endDate.text = activityRow.endDate
                cell.progressParticipantLabel.text = "참여인원 \(activityRow.person)명 남았습니다!"
                cell.progressCountLabel.text = "\(activityRow.currentPerson)/\(activityRow.personLimit)"
                
                // progress bar
                let progress = Float(activityRow.currentPerson) / Float(activityRow.personLimit)
                cell.progress.progress = progress
                
                cell.selectionStyle = .none
            }
                // 신청완료된 농활
            else if activityRow.state == 1 {
                cell.reviewView.isHidden = false
                cell.progressView.isHidden = true
                cell.stateImageView.backgroundColor = #colorLiteral(red: 0, green: 0.7776415944, blue: 0.6786493063, alpha: 0.87)
                cell.mainImageView.kf.setImage(with: URL(string: gsno(activityRow.img)), placeholder: UIImage(named: "woman_select"))
                cell.countLabel.text = "\(indexPath.row + 1)"
                cell.titleLabel.text = activityRow.name
                cell.addressLabel.text = activityRow.addr
                cell.priceLabel.text = "\(activityRow.price)"
                cell.startDate.text = activityRow.startDate
                cell.endDate.text = activityRow.endDate
                
                cell.selectionStyle = .none
                
                // 후기를 썼을 경우
                if activityRow.rState == 1 {
                    cell.reviewButton.setTitle("후기수정", for: .normal)
                    
                    cell.delegate = self
                    
                    //cell.reviewButton.addTarget(self, action: #selector(reviewClickAction(_:)), for: .touchUpInside)
                    //cell.reviewButton.tag = idx
                }
                    // 후기를 안 썼을 경우
                else {
                    cell.reviewButton.setTitle("후기작성", for: .normal)
                    
                    //                    let idx = activityRow.idx
                    //                    cell.reviewButton.addTarget(self, action: #selector(reviewClickAction(_:)), for: .touchUpInside)
                    //                    cell.reviewButton.tag = idx
                }
            }
            return cell
            
        }
    }
    
    
    @objc func reviewClickAction(_ sender: UIButton) {
        guard let reviewWriteVC = self.storyboard?.instantiateViewController(
            withIdentifier : "ReviewWriteViewController"
            ) as? ReviewWriteViewController
            else{ return }
        self.navigationController?.pushViewController(reviewWriteVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
}
