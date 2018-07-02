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
    
    func setCollectionViewDataSourceDelegate(forRow row: Int) {
        newCollectionView.delegate = self
        newCollectionView.dataSource = self
        newCollectionView.tag = row
        newCollectionView.reloadData()
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

extension NewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewCollectionViewCell", for: indexPath) as! NewCollectionViewCell
        
        cell.imageView.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        cell.periodLabel.text = "1박2일"
        cell.newLabel.text = "new"
        cell.titleLabel.text = "제주 감귤 농장"
        cell.addressLabel.text = "제주 서귀포시"
        cell.priceLabel.text = "20,000원"
        
        return cell
    }
}

