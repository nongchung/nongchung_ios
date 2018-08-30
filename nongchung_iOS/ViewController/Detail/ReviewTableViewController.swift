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
    var averageStar : Double = 0.0
    var totalStar : Double = 0.0
    var starCount : Int?
    
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

        ReviewService.reviewInit(scheIdx: Int(gsno(nhIdx))!, completion: { (reviewData) in

            self.reviews = reviewData

            if self.reviews.count == 0{
                self.noMyWriteImageView.isHidden = false
            }
            else{
                self.noMyWriteImageView.isHidden = true
                for i in reviewData{
                    self.totalStar += i.star!
                }
                self.starCount = reviewData.count
                self.averageStar = self.totalStar / Double(self.starCount!)
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
            cell.starLabel.text = "\(Double(averageStar/2.0).roundTo(places: 1))"
            cell.starImageView.image = UIImage(named: cell.starCalculator(star: averageStar))
            
            return cell
        } else {
            let index = reviews[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
            
            cell.nameLabel.text = index.name
            cell.dateLabel.text = index.startDate
            cell.contentLabel.text = index.content
            cell.profileImageView.imageFromUrl(index.uimg, defaultImgPath: "login_image")
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.width / 2
            cell.profileImageView.layer.masksToBounds = true
            
            cell.starImageView.image = UIImage(named: cell.starCalculator(star: index.star!))
            
            if index.star! <= 6.0 && index.star! > 4.0 {
                cell.starLabel.text = "좋았어요!"
            } else if index.star! <= 10.0 && index.star! > 8.0 {
                cell.starLabel.text = "강력추천해요!"
            } else if index.star! <= 4.0 && index.star! > 2.0{
                cell.starLabel.text = "나쁘지 않았어요!"
            }
            else if index.star! <= 2.0 {
                cell.starLabel.text = "추천하지 않아요ㅠ"
            }
            
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
