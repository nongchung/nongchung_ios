//
//  AllListViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 12..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import ESPullToRefresh

class AllListViewController: UIViewController {

    var allList: [AllListDataVO] = [AllListDataVO]()
    var isEnd: Int?
    var viewName: String?
    let ud = UserDefaults.standard
    var idx: Int = 6
    var count: Int = 1

    @IBOutlet weak var allListTableView: UITableView!
    
    @IBAction func backButtonClickAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarSetting()
        
        allListTableView.delegate = self
        allListTableView.dataSource = self
        

        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        allListInit()
        self.allListTableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.allListTableView.es.autoPullToRefresh()
        }
        
    }
    
    func navigationBarSetting(){
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : (UIFont(name: "NanumSquareRoundB", size: 18))!, NSAttributedStringKey.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.white
    }
    
    private func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.isEnd == 1 {
                self.allListTableView.es.noticeNoMoreData()
            } else {
                self.idx = self.idx * self.count
                self.allListInit()
            }
        }
    }
    
    func allListInit() {
        count = count + 1
        //MARK: 로그인을 안 했을 경우
        if ud.string(forKey: "token") == nil  {
            switch viewName {
            //MARK: 인기 농활 모두보기
            case "인기" :
                AllListService.popListInit(idx: idx) { (isEnd, allListData) in
                    self.isEnd = isEnd
                    self.allList += allListData
                    self.allListTableView.reloadData()
                }
            //MARK: 새로운 농활 모두보기
            case "뉴" :
                AllListService.newListInit(idx: idx) { (isEnd, allListData) in
                    self.isEnd = isEnd
                    self.allList += allListData
                    self.allListTableView.reloadData()
                }
            default:
                print("error")
            }
            allListTableView.reloadData()
        }
            //MARK: 로그인을 했을 경우
        else {
            switch viewName {
            //MARK: 인기 농활 모두보기
            case "인기" :
                AllListService.popListLoginInit(idx: idx) { (isEnd, allListData) in
                    self.isEnd = isEnd
                    self.allList += allListData
                    self.allListTableView.reloadData()
                }
            //MARK: 새로운 농활 모두보기
            case "뉴" :
                AllListService.newListLoginInit(idx: idx) { (isEnd, allListData) in
                    self.isEnd = isEnd
                    self.allList += allListData
                    self.allListTableView.reloadData()
                }
            default:
                print("error")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewName == "인기" {
            self.title = "이번 주 인기 농활"
        } else {
            self.title = "새로운 농활"
        }
    }

}

extension AllListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllListTableViewCell", for: indexPath) as! AllListTableViewCell
        
        cell.mainImageView.kf.setImage(with: URL(string: allList[indexPath.row].img!), placeholder: #imageLiteral(resourceName: "login_image"))
        cell.titleLabel.text = allList[indexPath.row].name
        cell.addressLabel.text = allList[indexPath.row].addr
        cell.priceLabel.text = String(gino(allList[indexPath.row].price))
        
        cell.heartButton.tag = allList[indexPath.row].nhIdx!
        cell.heartButton.addTarget(self, action: #selector(heartButtonAction), for: .touchUpInside)
        
        //MARK: 좋아요 안 했을 때
        if allList[indexPath.row].isBooked == nil || allList[indexPath.row].isBooked == 0 {
            cell.heartButton.setImage(#imageLiteral(resourceName: "main_heart_empty"), for: .normal)
        }
        else{
            cell.heartButton.setImage(#imageLiteral(resourceName: "main_heart_fill"), for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = allList[indexPath.row]

    }
    
    //MARK: 좋아요 통신
    @objc func heartButtonAction(_ sender: UIButton) {
        if sender.imageView?.image == #imageLiteral(resourceName: "main_heart_empty") && ud.string(forKey: "token") == nil{
            NotificationCenter.default.post(name: .noLoginUser, object: nil)
        }
        else if sender.imageView?.image == #imageLiteral(resourceName: "main_heart_empty") && ud.string(forKey: "token") != nil{
            HeartService.likeAddNetworking(nhIdx: sender.tag) {
                sender.setImage(#imageLiteral(resourceName: "main_heart_fill"), for: .normal)
            }
        }
        else{
            HeartService.likeDeleteNetworking(nhIdx: sender.tag) {
                sender.setImage(#imageLiteral(resourceName: "main_heart_empty"), for: .normal)
            }
        }
    }
}
