//
//  MainViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import SJSegmentedScrollView
import NotificationBannerSwift

extension Notification.Name{
    static let gotoIntroduce = Notification.Name("gotoIntroduce")
    static let gotoMain = Notification.Name("gotoMain")
}

class MainViewController: UIViewController, NetworkCallback {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBAction func imsi(_ sender: Any) {

    }
    
    //MARK: From Server Data - 홈
    var homeResultData : MainVO?
    var adsData : [AdsVO]?
    var populNhData : [PopulNhVO]?
    var newNhData : [NewNhVO]?
    var populFarmData : [PopulFarmVO]?
    
    //MARK: From Server Data - 농활보기
    var responseMessage : IntroduceVO?
    var imageData : [String]?
    var nhInfoData : NhInfoVO?
    var friendsInfoData : [FriendsInfoVO]?
    var farmerInfoData : FarmerInfoVO?
    var scheduleData : [ScheduleVO]?
    var nearestStartDateData : String?
    var allStartDateData : [AllStartDateVO]?
    
    
    var nhIdx : Int?
    let ud = UserDefaults.standard
    
    var indicator = UIActivityIndicatorView()
    let segmentedController = SJSegmentedViewController()
    
    @IBAction func unwindToMain(segue:UIStoryboardSegue) {
        if segue.source as? DoneApplyViewController != nil{
            segue.source.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Main Load 전 Loading Indicator
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    //MARK: 농활소개 Push idx Notification 알림
    @objc func gotoIntroduce(notification: NSNotification){
        nhIdx = gino(notification.userInfo!["nhIdx"] as? Int)
        let model = IntroduceModel(self)
        model.introuduceNetworking(idx: gino(nhIdx), token: gsno(ud.string(forKey: "token")))
        

    }
    
    //MARK: 신청완룔 홈 Root Change 알림
    @objc func gotoMain(notification: NSNotification){
        let banner = NotificationBanner(title: "신청 완료", subtitle: "농활이 신청되었습니다.", style: .success)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            banner.show(queuePosition: .front)
            banner.haptic = .heavy
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0){
            banner.dismiss()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mainTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self,selector: #selector(gotoIntroduce),name: .gotoIntroduce,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotoMain), name: .gotoMain, object: nil)
        
        //MARK: TableView Layout Setting
        mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        mainTableView.tableFooterView = UIView(frame: CGRect.zero)
        mainTableView.tableHeaderView = UIView(frame: CGRect.zero)
        
        //MARK: Present FadeOut Method
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        view.layer.add(transition, forKey: kCATransition)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator()
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
        
        //MARK: TabBar Setting
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
        
        let model = MainModel(self)
        model.home(token: gsno(ud.string(forKey: "token")))
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    func networkResult(resultData: Any, code: String) {
        
        switch code {
        case "Success To Get Detail Information": // 농활보기 Networking
            responseMessage = resultData as? IntroduceVO

            guard let detailVC = self.storyboard?.instantiateViewController(
                withIdentifier : "DetailViewController"
                ) as? DetailViewController
                else{return}
            detailVC.responseMessage = responseMessage
            detailVC.segmentedSetting()
            detailVC.nhIdx = nhIdx
            detailVC.modalTransitionStyle = .crossDissolve
            
            let navigationControlr = UINavigationController(rootViewController: detailVC)
            self.present(navigationControlr, animated: true, completion: nil)

        case "Null Value":
            let errmsg = resultData as? String
            simpleAlert(title: "오류", msg: gsno(errmsg))
        case "Internal Server Error":
            let errmsg = resultData as? String
            simpleAlert(title: "오류", msg: gsno(errmsg))
        case "No nonghwal activity":
            let errmsg = resultData as? String
            simpleAlert(title: "오류", msg: gsno(errmsg))
        
        case "Success To Get Information": // Home Networking
            indicator.stopAnimating()
            indicator.hidesWhenStopped = true
            
            homeResultData = resultData as? MainVO
            adsData = homeResultData?.ads
            populNhData = homeResultData?.populNh
            newNhData = homeResultData?.newNh
            populFarmData = homeResultData?.populFarm
            
            mainTableView.delegate = self
            mainTableView.dataSource = self
            mainTableView.reloadData()
            
        default:
            break
        }
    }
    
    func networkFailed() {
        simpleAlert(title: "인터넷 오류", msg: "네트워크 연결을 확인하세요.")
    }
    
    
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource{
    
    //MARK: TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdTableViewCell", for: indexPath) as! AdTableViewCell
            cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
            if adsData != nil{
                cell.adsData = adsData
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopularListTableViewCell", for: indexPath) as! PopularListTableViewCell
            cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
            if populNhData != nil{
                cell.populNhData = populNhData
            }
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewTableViewCell", for: indexPath) as! NewTableViewCell
            cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
            if newNhData != nil{
                cell.newNhData = newNhData
            }
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeTableViewCell", for: indexPath) as! ThemeTableViewCell
            cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopFarmTableViewCell", for: indexPath) as! PopFarmTableViewCell
            cell.setCollectionViewDataSourceDelegate(forRow: indexPath.row)
            if populFarmData != nil{
                cell.populFarmData = populFarmData
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}




