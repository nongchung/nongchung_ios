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
    
    var reviews: [ReviewDataVO] = [ReviewDataVO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myReviewTableView.delegate = self
        myReviewTableView.dataSource = self
        
        myReviewTableView.separatorStyle = .none
        myReviewTableView.rowHeight = UITableViewAutomaticDimension
        
        reviewInit()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func reviewInit() {
        ReviewService.reviewInit(completion: { (reviewData) in
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
        
        cell.nameLabel.text = reviews[indexPath.row].name
        cell.dateLabel.text = reviews[indexPath.row].startDate
        cell.contentLabel.text = reviews[indexPath.row].content
        if reviews[indexPath.row].img.count == 0 {
            cell.ImageCollectionView.removeFromSuperview()
        } else {
            cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row, imageArray: reviews[indexPath.row].img)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
