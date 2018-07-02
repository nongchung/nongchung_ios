
//
//  MainViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var mainSecondCollectionView: UICollectionView!
    @IBOutlet weak var mainFirstCollectionView: UICollectionView!
    
    var mains : [Main] = [Main]()
    var mainAds : [MainAds] = [MainAds]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewInit()
    }
    
    func collectionViewInit() {
        mainFirstCollectionView.delegate = self; mainFirstCollectionView.dataSource = self
        mainSecondCollectionView.delegate = self; mainSecondCollectionView.dataSource = self
        
//        MainService.mainInit { (MainData) in
//            self.mains = MainData
//            self.mainAds = MainData
//            self.mainFirstCollectionView.reloadData()
//            self.mainSecondCollectionView.reloadData()
//        }
//
//        BoardService.boardInit { (boardData) in
//            self.boards = boardData
//            self.boardCollectionView.reloadData()
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainFirstCollectionView {
            return mainAds.count
        } else {
            return mains.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainFirstCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainFirstCollectionViewCell", for: indexPath) as! MainFirstCollectionViewCell
            
        
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainSecondCollectionViewCell", for: indexPath) as! MainSecondCollectionViewCell
            
            return cell
        }
            
            
            
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardCollectionViewCell", for: indexPath) as! BoardCollectionViewCell
//            
//            
//            cell.boardImageView.kf.setImage(with: URL(string: gsno(boards[indexPath.row].board_photo)), placeholder: UIImage())
//            cell.boardTitle.text = boards[indexPath.row].board_title
//            cell.boardNickname.text = boards[indexPath.row].user_id
//            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MM/dd HH:mm"
//            cell.boardDate.text = dateFormatter.string(from: boards[indexPath.row].board_writetime)
//            
//            return cell
            
            
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCollectionViewCell", for: indexPath) as! PageCollectionViewCell
//
//            cell.pageImageView.image = imageArray[indexPath.row]
//
//            return cell
//        } else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WebtoonCollectionViewCell", for: indexPath) as! WebtoonCollectionViewCell
//
//            cell.webImageView.image = imageArray[indexPath.row]
//            cell.webTitle.text = "\(indexPath.row)"
//
//            return cell
//        }
    }

}
