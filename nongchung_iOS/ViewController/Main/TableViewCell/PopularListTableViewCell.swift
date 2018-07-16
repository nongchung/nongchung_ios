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
    let ud = UserDefaults.standard
    
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

extension PopularListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if populNhData?.count != 0 || populNhData != nil{
//            return (populNhData?.count)!
//        }
//        else {
//            return 1
//        }
        var pcount = 0
        pcount = (populNhData?.count)!
        return pcount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularListCollectionViewCell", for: indexPath) as! PopularListCollectionViewCell
        let index = populNhData![indexPath.row]
        cell.imageView.imageFromUrl(index.img, defaultImgPath: index.img!)
        cell.periodImageView.image = UIImage(named: periodCalculator(period: index.period!))
        cell.starImage.image = UIImage(named: starCalculator(star: index.star!))
        cell.titleLabel.text = index.name
        cell.addressLabel.text = index.addr
        cell.priceLabel.text = "\(index.price!)원"
        
        cell.heartButton.tag = index.nhIdx!
        cell.heartButton.addTarget(self, action: #selector(heartButtonAction), for: .touchUpInside)
        //MARK: 좋아요 안 했을 때
        if index.isBooked == nil || index.isBooked == 0{
            cell.heartButton.setImage(#imageLiteral(resourceName: "main_heart_empty"), for: .normal)
        }
        else{
            cell.heartButton.setImage(#imageLiteral(resourceName: "main_heart_fill"), for: .normal)
        }

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = populNhData![indexPath.row]
        NotificationCenter.default.post(name: .gotoIntroduce, object: nil, userInfo: ["nhIdx" : index.nhIdx!])
    }
}
