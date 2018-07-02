//
//  FirstTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class FirstTableViewCell: UITableViewCell {
    let colorArray = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)]
    let imageArray = [#imageLiteral(resourceName: "alarm-clock"), #imageLiteral(resourceName: "alarm-clock")]
    
    @IBOutlet weak var firstCollectionView: UICollectionView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        firstCollectionView.register(FirstCollectionViewCell.self, forCellWithReuseIdentifier: "FirstCollectionViewCell")
//        collectionViewInit()
//        firstCollectionView.delegate = self
//        firstCollectionView.dataSource = self

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func collectionViewInit() {

    }
}

extension FirstTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = firstCollectionView.dequeueReusableCell(withReuseIdentifier: "FirstCollectionViewCell", for: indexPath) as! FirstCollectionViewCell
        
        cell.imageView.image = imageArray[indexPath.row]
        
        return cell
    }

}
