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
import NotificationBannerSwift

class HeartViewController: UIViewController {
    
    @IBOutlet weak var heartTableView: UITableView!
    @IBOutlet var noZzimImageView: UIImageView!
    
    var hearts: [Heart] = [Heart]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSetting()
        
        heartTableView.delegate = self
        heartTableView.dataSource = self
        heartTableView.separatorStyle = .none
        
        heartTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        if UserDefaults.standard.string(forKey: "token") == nil {
            noZzimImageView.isHidden = false
        } else {
            noZzimImageView.isHidden = true
            heartInit()
        }
    }
    
    
    func heartInit() {
        HeartService.heartInit { (heartData) in
            self.hearts = heartData
            if self.hearts.count == 0{
                self.noZzimImageView.isHidden = false
            } else{
                self.noZzimImageView.isHidden = true
            }
            self.heartTableView.reloadData()
        }
    }
    
    func navigationSetting(){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "NanumSquareRoundB", size: 18)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
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
        
        let alert = UIAlertController(title: "좋아요를 취소하시겠습니까?", message: "", preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "확인", style: UIAlertActionStyle.destructive) {
            (action: UIAlertAction) in
            HeartService.likeDeleteNetworking(nhIdx: sender.tag) {
                self.heartInit()
                let banner = NotificationBanner(title: "취소 완료", subtitle: "찜한 농활이 취소되었습니다.", style: .danger)
                banner.show()
                banner.autoDismiss = true
                banner.haptic = .heavy
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

