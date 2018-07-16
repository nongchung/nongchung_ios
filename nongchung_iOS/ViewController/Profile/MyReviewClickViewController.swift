//
//  MyReviewClickViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 9..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class MyReviewClickViewController: UIViewController {
    @IBOutlet weak var clickCollectionView: UICollectionView!
    
    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var imageArray : [String]?
    var index: Int?
    var onceOnly = false
    var imageArrayCount : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clickCollectionView.delegate = self
        clickCollectionView.dataSource = self
        imageArrayCount = imageArray?.count
        
        self.navigationItem.hidesBackButton = false
        
        
        navigationController?.navigationBar.barTintColor = UIColor.white
    
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font : (UIFont(name: "NanumSquareRoundB", size: 18))!, NSAttributedStringKey.foregroundColor: UIColor.black], for: .normal)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : (UIFont(name: "NanumSquareRoundB", size: 18))!, NSAttributedStringKey.foregroundColor: UIColor.black]

        
    }
    
}

extension MyReviewClickViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.x / scrollView.frame.size.width + 1
        self.title = "\(Int(currentPage))/\(gino(imageArrayCount))"
        self.clickCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (imageArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyReviewClickCollectionViewCell", for: indexPath) as! MyReviewClickCollectionViewCell
        
        cell.imageView.kf.setImage(with: URL(string: imageArray![indexPath.row]), placeholder: #imageLiteral(resourceName: "login_image"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
            let indexToScrollTo = IndexPath(item: index!, section: 0)
            self.clickCollectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
            self.title = "\(gino(index)+1)/\(gino(imageArrayCount))"
            onceOnly = true
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 450*self.view.frame.height/667)
    }
    
}
