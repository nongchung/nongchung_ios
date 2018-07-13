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
    
    let ud = UserDefaults.standard
    
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
    
    @objc func heartButtonAction(_ sender: UIButton) {
        if sender.imageView?.image == #imageLiteral(resourceName: "main_heart_empty") && ud.string(forKey: "token") == nil{
            NotificationCenter.default.post(name: .noLoginUser, object: nil)
        }
        if sender.imageView?.image == #imageLiteral(resourceName: "main_heart_empty"){
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

extension NewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (newNhData?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewCollectionViewCell", for: indexPath) as! NewCollectionViewCell
        let index = newNhData![indexPath.row]
        cell.imageView.imageFromUrl(index.img, defaultImgPath: index.img!)
        cell.periodImageView.image = UIImage(named: periodCalculator(period: index.period!))
        cell.titleLabel.text = index.name
        cell.addressLabel.text = index.addr
        cell.priceLabel.text = "\(index.price!)원"
        
        cell.heartButton.tag = index.nhIdx!
        cell.heartButton.addTarget(self, action: #selector(heartButtonAction), for: .touchUpInside)
        //MARK: 좋아요 안 했을 때
        if index.isBooked == 0 {
            cell.heartButton.setImage(#imageLiteral(resourceName: "main_heart_empty"), for: .normal)
        }
            //MARK: 좋아요 했을 때
        else {
            cell.heartButton.setImage(#imageLiteral(resourceName: "main_heart_fill"), for: .normal)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = newNhData![indexPath.row]
        NotificationCenter.default.post(name: .gotoIntroduce, object: nil, userInfo: ["nhIdx" : index.nhIdx!])
    }
}

