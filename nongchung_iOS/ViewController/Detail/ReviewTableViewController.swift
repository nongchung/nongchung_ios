//
//  ReviewTableViewController.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 4..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class ReviewTableViewController: UIViewController {
    
    
    @IBOutlet weak var customTableView: UITableView!
    @IBOutlet var noMyWriteImageView: UIImageView!
    
    var nhIdx : String?
    var star : Double?
    
    var reviews: [ReviewDataVO] = [ReviewDataVO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTableView.delegate = self
        customTableView.dataSource = self
        customTableView.tableFooterView = UIView(frame: CGRect.zero)
        customTableView.tableHeaderView = UIView(frame: CGRect.zero)
        customTableView.separatorInset = UIEdgeInsets(top: 0, left: self.view.frame.width, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reviewInit()
    }
    
    func reviewInit() {
        print(Int(gsno(nhIdx))!)
        ReviewService.reviewInit(scheIdx: Int(gsno(nhIdx))!, completion: { (reviewData) in
            self.reviews = reviewData
            if self.reviews.count == 0{
                self.noMyWriteImageView.isHidden = false
            }
            else{
                self.noMyWriteImageView.isHidden = true
            }
            self.customTableView.reloadData()
            
        })
    }
    
}

extension ReviewTableViewController : UITableViewDelegate, UITableViewDataSource, SJSegmentedViewControllerViewSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return reviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewStarTableViewCell", for: indexPath) as! ReviewStarTableViewCell
            
            cell.starLabel.text = "\(star!/2)"
            cell.starImageView.image = UIImage(named: cell.starCalculator(star: star!))
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
            let index = reviews[indexPath.row]
            cell.nameLabel.text = index.name
            cell.dateLabel.text = index.startDate
            cell.contentLabel.text = index.content
            //cell.starImageView.image = UIImage(named: starCalculator(star: index.star!))
            //cell.starLabel.text
            if index.rvImages?.count == 0 {
                cell.imageCollectionView.removeFromSuperview()
            } else {
                cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row, imageArray: index.rvImages!)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        
        return customTableView
    }
}
