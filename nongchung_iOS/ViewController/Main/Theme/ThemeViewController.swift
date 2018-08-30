//
//  ThemeViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 12..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import Kingfisher

class ThemeViewController: UIViewController, NetworkCallback {

    @IBOutlet weak var themeTableView: UITableView!
    
    var themeIdx: Int?
    
    var themes: [ThemeDataVO] = [ThemeDataVO]()
    let token = UserDefaults.standard.string(forKey: "token")
    var nhIdx : Int?
    var responseMessageToDetail : IntroduceVO?
    var imageArray = [#imageLiteral(resourceName: "main_theme3"), #imageLiteral(resourceName: "main_theme2"), #imageLiteral(resourceName: "main_theme5"), #imageLiteral(resourceName: "main_theme4"), #imageLiteral(resourceName: "main_theme1")]
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarSetting()
        themeTableView.delegate = self
        themeTableView.dataSource = self
        themeTableView.separatorInset = UIEdgeInsets(top: 0, left: self.view.frame.size.width, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        themeInit()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func navigationBarSetting(){
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : (UIFont(name: "NanumSquareRoundB", size: 18))!, NSAttributedStringKey.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.white
    }

    func themeInit() {
        var themePlusIdx = gino(themeIdx) + 1
        ThemeService.themeInit(themeIdx: gino(themePlusIdx)) { (themeData) in
            self.themes = themeData
            self.themeTableView.reloadData()
        }
    }
    
    func networkResult(resultData: Any, code: String) {
        if code == "Success To Get Detail Information"{
            responseMessageToDetail = resultData as? IntroduceVO
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let detailVC = storyBoard.instantiateViewController(
                withIdentifier : "DetailViewController"
                ) as? DetailViewController
                else{return}
            detailVC.responseMessage = responseMessageToDetail
            detailVC.segmentedSetting()
            detailVC.nhIdx = nhIdx
            detailVC.modalTransitionStyle = .crossDissolve
            
            let navigationControlr = UINavigationController(rootViewController: detailVC)
            self.present(navigationControlr, animated: true, completion: nil)
            
        }
    }
    
    func networkFailed() {
        simpleAlert(title: "네트워크 오류", msg: "인터넷 연결을 확인해주세요.")
    }
}

extension ThemeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return themes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeImageTableViewCell", for: indexPath) as! ThemeImageTableViewCell
            cell.selectionStyle = .none
            cell.themeImageView.image = imageArray[gino(themeIdx)]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeListTableViewCell", for: indexPath) as! ThemeListTableViewCell
            let index = themes[indexPath.row]
            cell.selectionStyle = .none
            cell.mainImageView.kf.setImage(with: URL(string: gsno(index.fImg)), placeholder: #imageLiteral(resourceName: "main_image3"))
            cell.titleLabel.text = index.name
            cell.addressLabel.text = index.addr
            cell.priceLabel.text = "\(gino(index.price))원"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            let index = themes[indexPath.row]
            let model = IntroduceModel(self)
            nhIdx = index.nhIdx
            model.introuduceNetworking(idx: gino(nhIdx), token: gsno(token))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
