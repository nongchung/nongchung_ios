//
//  ThemeTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 2..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class ThemeTableViewCell: UITableViewCell {
    @IBOutlet weak var allButton: UIButton!
    
    @IBOutlet weak var themeCollectionView: UICollectionView!
    
    func setCollectionViewDataSourceDelegate(forRow row: Int) {
        themeCollectionView.delegate = self
        themeCollectionView.dataSource = self
        themeCollectionView.tag = row
        themeCollectionView.reloadData()
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

extension ThemeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThemeCollectionViewCell", for: indexPath) as! ThemeCollectionViewCell
        
        cell.imageView.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        cell.subLabel.text = "어쩌고"
        cell.mainLabel.text = "저쩌구"
        
        return cell
    }
}
