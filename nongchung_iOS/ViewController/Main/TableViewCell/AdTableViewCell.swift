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
    
    var adsData : [AdsVO]? = nil{
        didSet{
            AdCollectionView.reloadData()
        }
    }
    
    func setCollectionViewDataSourceDelegate(forRow row: Int) {
        
        AdCollectionView.delegate = self
        AdCollectionView.dataSource = self
        AdCollectionView.backgroundColor = UIColor.white
        AdCollectionView.tag = row
        AdCollectionView.reloadData()
    }
    override func awakeFromNib() {
        let timer =  Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
    }
    
}

extension AdTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: CollectionView Timer Paging
    @objc func scrollToNextCell(){
        
        //get cell size
        let cellSize = AdCollectionView.frame.size
        
        //get current content Offset of the Collection view
        let contentOffset = AdCollectionView.contentOffset
        
        if AdCollectionView.contentSize.width <= AdCollectionView.contentOffset.x + cellSize.width
        {
            let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            AdCollectionView.scrollRectToVisible(r, animated: true)
            
        } else {
            let r = CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            AdCollectionView.scrollRectToVisible(r, animated: true);
        }
        
    }
    
    //MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if adsData?.count == nil{
            return 1
        }else{
            return (adsData?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdCollectionViewCell", for: indexPath) as! AdCollectionViewCell
        let index = adsData![indexPath.row]
        cell.imageView.imageFromUrl(index.img, defaultImgPath: index.img!)
        cell.mainLabel.text = index.title
        cell.subLabel.text = index.description
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
