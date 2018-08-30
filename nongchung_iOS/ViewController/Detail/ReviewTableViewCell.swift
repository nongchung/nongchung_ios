//
//  ReviewTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 11..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var array = [String]()
    
    func setCollectionViewDataSourceDelegate(forRow row: Int, imageArray: Array<String>) {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.tag = row
        array = imageArray
        
        imageCollectionView.reloadData()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //increaseSeparatorHeight()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension ReviewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCollectionViewCell", for: indexPath) as! ReviewCollectionViewCell
        
        cell.imageView.kf.setImage(with: URL(string: array[indexPath.row]), placeholder: #imageLiteral(resourceName: "login_image"))
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let storyBoard = UIStoryboard(name: "More", bundle: nil)
//        guard let clickVC = storyBoard.instantiateViewController(withIdentifier: "MyReviewClickViewController") as? MyReviewClickViewController else { return }
//        let navController = UINavigationController(rootViewController: clickVC)
//        clickVC.imageArray = self.array
//        clickVC.index = indexPath.row
//        
//        self.window?.inputViewController?.presentedViewController?.present(navController, animated: true, completion: nil)
//        
//    }
}
