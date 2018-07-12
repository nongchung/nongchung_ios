//
//  HeartViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 4..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class HeartViewController: UIViewController {
    @IBOutlet weak var heartTableView: UITableView!
    
    var hearts: [Heart] = [Heart]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heartTableView.delegate = self
        heartTableView.dataSource = self
        heartTableView.separatorStyle = .none
        
        heartTableView.rowHeight = UITableViewAutomaticDimension
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        //heartInit()
    }
    
    func heartInit() {
        HeartService.heartInit { (heartData) in
            self.hearts = heartData
            self.heartTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        heartInit()
        //heartTableView.reloadData()
    }
}



extension HeartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hearts.count
    }
    
    @objc func heartButtonClickAction(_ sender: UIButton) {
        print("하트버튼")
        print(sender.tag)
        
        let alert = UIAlertController(title: "좋아요를 취소하시겠습니까?", message: "", preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "확인", style: UIAlertActionStyle.destructive) {
            (action: UIAlertAction) in
            HeartService.likeDeleteNetworking(nhIdx: sender.tag) {
                print("찜 삭제 성공")
                self.heartInit()
            }
        }
        let cancleButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(doneButton)
        alert.addAction(cancleButton)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeartTableViewCell", for: indexPath) as! HeartTableViewCell
        
        var heart = hearts[indexPath.row].idx
        
        cell.heartImageView.kf.setImage(with: URL(string: gsno(hearts[indexPath.row].img)), placeholder: UIImage(named: "woman_select"))
        //cell.heartImageView?.contentMode = UIViewContentMode.scaleAspectFit
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.imageView?.contentMode = UIViewContentMode.scaleToFill
        cell.addressLabel.text = hearts[indexPath.row].addr
        cell.priceLabel.text = String(hearts[indexPath.row].price)+"원"
        cell.periodLabel.text = hearts[indexPath.row].period
        cell.titleLabel.text = hearts[indexPath.row].name
        cell.heartButton.addTarget(self, action: #selector(heartButtonClickAction(_:)), for: .touchUpInside)
        cell.heartButton.tag = heart
        
        return cell
        
    }
    
}
