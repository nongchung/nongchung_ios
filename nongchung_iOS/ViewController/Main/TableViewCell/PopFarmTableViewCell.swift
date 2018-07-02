//
//  PopFarmTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 2..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class PopFarmTableViewCell: UITableViewCell {
    @IBOutlet weak var allButton: UIButton!
    
    @IBOutlet weak var popFarmCollectionView: UICollectionView!
    
    func setCollectionViewDataSourceDelegate(forRow row: Int) {
        popFarmCollectionView.delegate = self
        popFarmCollectionView.dataSource = self
        popFarmCollectionView.tag = row
        popFarmCollectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension PopFarmTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopFarmCollectionViewCell", for: indexPath) as! PopFarmCollectionViewCell
        
        cell.imageView.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        cell.titleLabel.text = "제주 감귤 농장"
        cell.addressLabel.text = "제주 서귀포시"
        cell.profileImageView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        return cell
    }
}
