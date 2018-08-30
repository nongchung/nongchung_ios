//
//  HeaderViewController.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 7..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class HeaderViewController : UIViewController{
    
    @IBOutlet var headerCollectionView: UICollectionView!
    
    
    var imageData : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
    }
}

extension HeaderViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageData == nil{
            return 1
        }
        else {
            return (imageData?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionViewCell", for: indexPath) as! HeaderCollectionViewCell
        let index = imageData![indexPath.row]
        cell.headerImageView.imageFromUrl(index, defaultImgPath: "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        return CGSize(width: width, height: self.view.frame.size.height)
    }
    
}
