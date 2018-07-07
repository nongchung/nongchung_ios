//
//  VolunteerCell.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 4..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class VolunteerCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var volunteerCollectionView: UICollectionView!
    
    var volunteerImageData : [FriendsInfoVO]? = nil{
        didSet{
            volunteerCollectionView.reloadData()
        }
    }
    func setCollectionViewDataSourceDelegate(forRow row: Int) {
        volunteerCollectionView.delegate = self
        volunteerCollectionView.dataSource = self
        volunteerCollectionView.backgroundColor = UIColor.white
        volunteerCollectionView.tag = row
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        increaseSeparatorHeight()
    }
    
}

extension VolunteerCell : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if volunteerImageData == nil{
            return 1
        } else {
            return (volunteerImageData?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VolunteerCollectionViewCell", for: indexPath) as! VolunteerCollectionViewCell
        let index = volunteerImageData![indexPath.row]
        cell.volunteerImageView.layer.masksToBounds = true
        cell.volunteerImageView.layer.cornerRadius = cell.volunteerImageView.frame.width / 2
        cell.volunteerImageView.imageFromUrl(index.img, defaultImgPath: "")
        return cell
    }
    
    
}

