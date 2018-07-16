//
//  MyReviewViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 7..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class MyReviewViewController: UIViewController {
    
    @IBOutlet weak var myReviewTableView: UITableView!
    
    var reviews: [MyReviewDataVO] = [MyReviewDataVO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        myReviewTableView.delegate = self
        myReviewTableView.dataSource = self
        
        myReviewTableView.separatorStyle = .none
        
        myReviewInit()
    }
    
    
    func myReviewInit() {
        ReviewService.myReviewInit(completion: { (reviewData) in
            self.reviews = reviewData
            self.myReviewTableView.reloadData()
        })
    }
    
}

extension MyReviewViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyReviewTableViewCell", for: indexPath) as! MyReviewTableViewCell
        cell.nongwhalLabel.text = "\(gsno(reviews[indexPath.row].nhName)) \(gsno(reviews[indexPath.row].period))"
        cell.nameLabel.text = gsno(reviews[indexPath.row].name)
        cell.dateLabel.text = gsno(reviews[indexPath.row].startDate)
        cell.contentLabel.text = gsno(reviews[indexPath.row].content)
        cell.profileImageView.kf.setImage(with: URL(string: gsno(reviews[indexPath.row].farmImg)), placeholder: #imageLiteral(resourceName: "reviwe_profile_image"))
        
        if reviews[indexPath.row].img?.count == 0 {
            cell.ImageCollectionView.isHidden = true
        } else {
            cell.ImageCollectionView.isHidden = false
            cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row, imageArray: reviews[indexPath.row].img!)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
