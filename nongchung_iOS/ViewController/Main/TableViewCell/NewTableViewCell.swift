//
//  NewTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 2..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class NewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newCollectionView: UICollectionView!
    @IBOutlet weak var allButton: UIButton!
    
    var newNhData : [NewNhVO]? = nil{
        didSet{
            newCollectionView.reloadData()
        }
    }
    
    func setCollectionViewDataSourceDelegate(forRow row: Int) {
        newCollectionView.delegate = self
        newCollectionView.dataSource = self
        newCollectionView.backgroundColor = UIColor.white
        newCollectionView.tag = row
        newCollectionView.reloadData()
    }
}

extension NewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (newNhData?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewCollectionViewCell", for: indexPath) as! NewCollectionViewCell
        let index = newNhData![indexPath.row]
        cell.imageView.imageFromUrl(index.img, defaultImgPath: "")
        cell.periodImageView.image = UIImage(named: periodCalculator(period: index.period!))
        cell.titleLabel.text = index.name
        cell.addressLabel.text = index.addr
        cell.priceLabel.text = index.price
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = newNhData![indexPath.row]
        NotificationCenter.default.post(name: .gotoIntroduce, object: nil, userInfo: ["nhIdx" : index.nhIdx!])
    }
}

