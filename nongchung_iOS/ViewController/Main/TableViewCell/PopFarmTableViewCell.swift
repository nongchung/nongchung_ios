//
//  PopFarmTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 2..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class PopFarmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var popFarmCollectionView: UICollectionView!
    
    var populFarmData : [PopulFarmVO]? = nil{
        didSet{
            popFarmCollectionView.reloadData()
        }
    }
    
    func setCollectionViewDataSourceDelegate(forRow row: Int) {
        popFarmCollectionView.delegate = self
        popFarmCollectionView.dataSource = self
        popFarmCollectionView.tag = row
        popFarmCollectionView.reloadData()
    }
}

extension PopFarmTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopFarmCollectionViewCell", for: indexPath) as! PopFarmCollectionViewCell
        let index = populFarmData![indexPath.row]
        cell.titleLabel.text = index.name
        cell.addressLabel.text = index.addr
        cell.profileImageView.layer.masksToBounds = true
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2
        cell.profileImageView.imageFromUrl(index.farmerImg!, defaultImgPath: index.farmerImg!)
        cell.imageView.imageFromUrl(index.farmImg!, defaultImgPath: index.farmImg!)
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let index = populFarmData![indexPath.row]
//
//        guard let farmVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FarmerViewController") as? FarmerViewController else { return }
//        farmVC.nhIdx = index.farmIdx!
//        farmVC.modalTransitionStyle = .crossDissolve
//        
//        let navigationControlr = UINavigationController(rootViewController: farmVC)
//        UIApplication.shared.keyWindow?.rootViewController?.present(navigationControlr, animated: true, completion: nil)
//    }
}
