//
//  PopularListTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 2..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class PopularListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var allButton: UIButton!
    
    var idx : Int?
    
    var populNhData : [PopulNhVO]? = nil{
        didSet{
            popularCollectionView.reloadData()
        }
    }
    
    func setCollectionViewDataSourceDelegate(forRow row: Int) {
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
        popularCollectionView.tag = row
        popularCollectionView.reloadData()
    }
}

extension PopularListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (populNhData?.count)!
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularListCollectionViewCell", for: indexPath) as! PopularListCollectionViewCell
        let index = populNhData![indexPath.row]
        cell.imageView.imageFromUrl(index.img, defaultImgPath: "")
        cell.periodImageView.image = UIImage(named: periodCalculator(period: index.period!))
        cell.starImage.image = UIImage(named: starCalculator(star: index.star!))
        cell.starLabel.text = "\(String(describing: index.star))"
        cell.titleLabel.text = index.name
        cell.addressLabel.text = index.addr
        cell.priceLabel.text = index.price
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = populNhData![indexPath.row]
        NotificationCenter.default.post(name: .gotoIntroduce, object: nil, userInfo: ["idx" : index.idx!])
    }
}
