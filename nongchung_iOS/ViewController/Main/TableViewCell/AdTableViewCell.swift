//
//  AdTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class AdTableViewCell: UITableViewCell {
    @IBOutlet weak var AdCollectionView: UICollectionView!
    
    func setCollectionViewDataSourceDelegate(forRow row: Int) {
        
        AdCollectionView.delegate = self
        AdCollectionView.dataSource = self
        AdCollectionView.tag = row
        AdCollectionView.reloadData()
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

extension AdTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdCollectionViewCell", for: indexPath) as! AdCollectionViewCell
        
        cell.imageView.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        cell.subLabel.text = "시즌 농활 특집"
        cell.mainLabel.text = "맛있는 귤과 함께하는 농활 특집"
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
