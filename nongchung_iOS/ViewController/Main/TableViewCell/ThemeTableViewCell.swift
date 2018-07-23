//
//  ThemeTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 2..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class ThemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var themeCollectionView: UICollectionView!
    var imageArray = [#imageLiteral(resourceName: "main_theme3"), #imageLiteral(resourceName: "main_theme2"), #imageLiteral(resourceName: "main_theme5"), #imageLiteral(resourceName: "main_theme4"), #imageLiteral(resourceName: "main_theme1")]
    
    func setCollectionViewDataSourceDelegate(forRow row: Int) {
        themeCollectionView.delegate = self
        themeCollectionView.dataSource = self
        themeCollectionView.tag = row
        themeCollectionView.reloadData()
    }
    
}

extension ThemeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    
    //MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThemeCollectionViewCell", for: indexPath) as! ThemeCollectionViewCell
        cell.imageView.image = imageArray[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: .gotoTheme, object: nil, userInfo: ["themeIdx":indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: UIScreen.main.bounds.size.width-32, height: contentView.frame.size.height-87.5)
    }
}
