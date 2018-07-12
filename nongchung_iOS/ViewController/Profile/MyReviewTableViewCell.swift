//
//  MyReviewTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 9..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class MyReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ImageCollectionView: UICollectionView!
    
    var array = [String]()
    
    func setCollectionViewDataSourceDelegate(forRow row: Int, imageArray: Array<String>) {
        ImageCollectionView.delegate = self
        ImageCollectionView.dataSource = self
        ImageCollectionView.tag = row
        array = imageArray
        print(array)
        
        ImageCollectionView.reloadData()
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

extension MyReviewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyReviewImageCollectionViewCell", for: indexPath) as! MyReviewImageCollectionViewCell
        
        cell.reviewImage.kf.setImage(with: URL(string: array[indexPath.row]), placeholder: #imageLiteral(resourceName: "login_image"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let clickVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyReviewClickViewController") as? MyReviewClickViewController else { return }
        clickVC.imageArray = self.array
        clickVC.index = indexPath.row
        
        self.window?.rootViewController?.present(clickVC, animated: true, completion: nil)
    }
}


