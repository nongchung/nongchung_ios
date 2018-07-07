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

}

extension ThemeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    
    //MARK: CollectionView Centering
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var closestCell : UICollectionViewCell = themeCollectionView.visibleCells[0];
        for cell in themeCollectionView!.visibleCells as [UICollectionViewCell] {
            let closestCellDelta = abs(closestCell.center.x - themeCollectionView.bounds.size.width/2.0 - themeCollectionView.contentOffset.x)
            let cellDelta = abs(cell.center.x - themeCollectionView.bounds.size.width/2.0 - themeCollectionView.contentOffset.x)
            if (cellDelta < closestCellDelta){
                closestCell = cell
            }
        }
        let indexPath = themeCollectionView.indexPath(for: closestCell)
        themeCollectionView.scrollToItem(at: indexPath!, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
    
    //MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThemeCollectionViewCell", for: indexPath) as! ThemeCollectionViewCell
        
        
        return cell
    }
}
