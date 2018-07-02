//
//  PopularListTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 2..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class PopularListTableViewCell: UITableViewCell {
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    @IBOutlet weak var allButton: UIButton!
    
    func setCollectionViewDataSourceDelegate(forRow row: Int) {
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
        popularCollectionView.tag = row
        popularCollectionView.reloadData()
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

extension PopularListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularListCollectionViewCell", for: indexPath) as! PopularListCollectionViewCell
        
        cell.imageView.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        cell.periodLabel.text = "1박2일"
        cell.starLabel.text = "4.5"
        cell.titleLabel.text = "제주 감귤 농장"
        cell.addressLabel.text = "제주 서귀포시"
        cell.priceLabel.text = "20,000원"
        
        return cell
    }
}

