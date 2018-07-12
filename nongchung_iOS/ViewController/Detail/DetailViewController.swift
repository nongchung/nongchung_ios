//
//  DetailVC.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 7..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import SJSegmentedScrollView
import NotificationBannerSwift

class DetailViewController : UIViewController, NetworkCallback {
    
    
    @IBOutlet var heartButton: UIBarButtonItem!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var containerView: UIView!
    @IBOutlet var popupCenterYConstraint: NSLayoutConstraint!
    @IBOutlet var popupTableView: UITableView!
    
    @IBOutlet var datePickerButton: UIButton!
    @IBOutlet var applyButton: UIButton!
    @IBOutlet var grayBackgroundButton: UIButton!
    @IBOutlet var applyCancelButton: UIButton!
    
    var dateFormatter: DateFormatter {
        get {
            let f = DateFormatter()
            f.dateFormat = "yyyy년 MM월 dd일"
            return f
        }
    }
    
    var responseMessage : IntroduceVO?
    
    let segmentedController = SJSegmentedViewController()
    var selectedSegment:SJSegmentTab?
    var offsetY: CGFloat = 0.0
    let ud = UserDefaults.standard
    var check = true
    
    //MARK: 농활 인덱스
    var nhIdx : Int?
    var schIdx : Int?
    var isBooked : Int?
    
    //MARK: 신청페이지 넘길 데이터
    var name : String?
    var addr : String?
    var period : String?
    var price : Int?
    var img : String?
    
    //MARK: 후기페이지 넘길 데이터
    var star : Double?
    
    var tempMyScheduleActivities : [Int]?
    
    @IBAction func backButtonClickAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    @objc func heartButtonAction(_ sender: UIBarButtonItem) {
//        if sender.image == #imageLiteral(resourceName: "main_heart_empty"){
//            HeartService.likeAddNetworking(nhIdx: sender.tag) {
//                print("하트 추가 성공")
//                sender.setBackgroundImage(#imageLiteral(resourceName: "main_heart_fill"), for: .normal, barMetrics: .default)
//            }
//        }
//        else{
//            HeartService.likeDeleteNetworking(nhIdx: sender.tag) {
//                print("하트 삭제 성공")
//                sender.setBackgroundImage(#imageLiteral(resourceName: "main_heart_empty"), for: .normal, barMetrics: .default)
//            }
//        }
//    }

    @IBAction func heartButtonAction(_ sender: UIBarButtonItem) {
        if sender.image == #imageLiteral(resourceName: "main_heart_empty"){
            HeartService.likeAddNetworking(nhIdx: gino(nhIdx)) {
                print("하트 추가 성공")
                sender.image = UIImage(named: "main_heart_fill")

            }
        }
        else{
            HeartService.likeDeleteNetworking(nhIdx: gino(nhIdx)) {
                print("하트 삭제 성공")
                sender.image = UIImage(named: "main_heart_empty")
            }
        }
    }
    
    
    override func viewDidLoad() {
        
        comparableMyActivity()
        name = responseMessage?.nhInfo?.name
        addr = responseMessage?.nhInfo?.addr
        period = responseMessage?.nhInfo?.period
        price = responseMessage?.nhInfo?.price
        img = responseMessage?.image![0]
        schIdx = responseMessage?.allStartDate![0].idx
        star = responseMessage?.nhInfo?.star
        isBooked = responseMessage?.nhInfo?.isBooked
        
        
        
        if isBooked == 0 || isBooked == nil{
            heartButton.image = UIImage(named: "main_heart_empty")
        } else {
            heartButton.image = UIImage(named: "main_heart_fill")
        }
        
        self.navigationController?.navigationBar.topItem?.title = name
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : (UIFont(name: "NanumSquareRoundB", size: 18))!, NSAttributedStringKey.foregroundColor: UIColor.black]
        
        popupTableView.delegate = self
        popupTableView.dataSource = self
        popupTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        popupTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        popupTableView.tableHeaderView = UIView.init(frame: CGRect.zero)
        
        grayBackgroundButton.isHidden = true
        grayBackgroundButton.addTarget(self, action: #selector(hiddenGrayButtonAction), for: .touchUpInside)
        
        applyButton.addTarget(self, action: #selector(applyButtonClickAction), for: .touchUpInside)
        applyCancelButton.addTarget(self, action: #selector(applyCancelButtonClickAction), for: .touchUpInside)


        
        datePickerButton.setTitle(responseMessage?.nearestStartDate, for: .normal)
        datePickerButton.addTarget(self, action: #selector(datePickerButtonClickAction), for: .touchUpInside)
        
        addChildViewController(segmentedController)
        containerView.addSubview(segmentedController.view)
        segmentedController.view.frame = self.containerView.bounds
        segmentedController.didMove(toParentViewController: self)
        segmentedSetting()
        
        self.view.layoutIfNeeded()
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = name
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : (UIFont(name: "NanumSquareRoundB", size: 18))!, NSAttributedStringKey.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    
    func segmentedSetting(){
        let headerVC = self.storyboard?.instantiateViewController(withIdentifier: "HeaderViewController") as! HeaderViewController
        headerVC.imageData = responseMessage?.image
        
        let informationVC = self.storyboard?.instantiateViewController(withIdentifier: "InformationTableViewController") as! InformationTableViewController
        informationVC.title = "농활소개"
        informationVC.nhInfoData = responseMessage?.nhInfo
        informationVC.friendsInfoData = responseMessage?.friendsInfo
        informationVC.farmerInfoData = responseMessage?.farmerInfo
        informationVC.scheduleData = responseMessage?.schedule
        informationVC.nearestStartDateData = responseMessage?.nearestStartDate
        informationVC.allStartDateData = responseMessage?.allStartDate
        
        let qnaVC = self.storyboard?.instantiateViewController(withIdentifier: "QnATableViewController") as! QnATableViewController
        qnaVC.title = "Q&A"
        
        let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewTableViewController") as! ReviewTableViewController
        reviewVC.title = "후기"
        reviewVC.nhIdx = responseMessage?.nhInfo?.nhIdx
        reviewVC.star = responseMessage?.nhInfo?.star
        
        //MARK: Segmented Control Setting
        segmentedController.segmentControllers = [informationVC, qnaVC, reviewVC]
        segmentedController.headerViewController = headerVC
        segmentedController.segmentViewHeight = 48.0
        segmentedController.selectedSegmentViewHeight = 4.0
        segmentedController.headerViewHeight = 225
        segmentedController.segmentTitleFont = UIFont(name: "NanumSquareRoundB", size: 16)!
        segmentedController.segmentTitleColor = UIColor.black
        segmentedController.selectedSegmentViewColor = #colorLiteral(red: 0.03921568627, green: 0.7411764706, blue: 0.6156862745, alpha: 1)
        segmentedController.segmentShadow = SJShadow.init(offset: CGSize(width: 0, height: 0), color: UIColor.clear, radius: 0, opacity: 0)
        segmentedController.segmentBounces = true
        segmentedController.delegate = self
    }
    
    func networkResult(resultData: Any, code: String) {
        if code == "Success To Cancel"{
            let banner = NotificationBanner(title: "취소 완료", subtitle: "농활이 취소되었습니다.", style: .danger)
            banner.show()
            banner.autoDismiss = true
            banner.haptic = .heavy
            applyCancelButton.isHidden = true
            applyButton.isHidden = false
            datePickerButton.isHidden = false
        }
    }
    
    func networkFailed() {
        simpleAlert(title: "인터넷 오류", msg: "네트워크 연결을 확인하세요.")
    }
}

extension DetailViewController: SJSegmentedViewControllerDelegate {
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        if selectedSegment != nil {
            selectedSegment?.titleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }

        if segmentedController.segments.count > 0 {
            selectedSegment = segmentedController.segments[index]
            selectedSegment?.titleColor(#colorLiteral(red: 0.03921568627, green: 0.7411764706, blue: 0.6156862745, alpha: 1))
        }
    }
}

extension DetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if responseMessage?.allStartDate == nil {
            return 1
        } else{
            return (responseMessage?.allStartDate?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopupCell", for: indexPath) as! PopupCell
        let index = responseMessage?.allStartDate![indexPath.row]
        cell.periodLabel.text = gsno(index?.startDate)
        cell.departureLabel.text = "오전 9시 출발"
        cell.leftLabel.text = "\(gino(index?.availPerson))명 남음"

        if index?.state == 0{
            cell.statusLabel.text = "참가가능"
            cell.statusLabel.textColor = #colorLiteral(red: 0.9490196078, green: 0.337254902, blue: 0.1254901961, alpha: 1)
        } else{
            cell.statusLabel.text = "모집마감"
            cell.statusLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.54)
            cell.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PopupCell
        let index = responseMessage?.allStartDate![indexPath.row]
        schIdx = index?.idx
        datePickerButton.setTitle(cell.periodLabel.text, for: .normal)
        datePickerButtonClickAction()
        if let myScheduleActivities = responseMessage?.myScheduleActivities{
            if myScheduleActivities.contains(gino(schIdx)) {
                applyCancelButton.isHidden = false
                applyButton.isHidden = true
                datePickerButton.isHidden = true
            }
            else{
                applyCancelButton.isHidden = true
                applyButton.isHidden = false
                datePickerButton.isHidden = false
            }
        }
    }
}

extension DetailViewController {
    
    //MARK: 이미 신청한건지 안한건지 Comparable
    func comparableMyActivity(){
        if let myScheduleActivities = responseMessage?.myScheduleActivities{
            if let allStartDate = responseMessage?.allStartDate{
                if myScheduleActivities.contains(gino(allStartDate[0].idx)){
                    check = false
                    schIdx = allStartDate[0].idx
                } else{
                    check = true
                }

            }
        }
        if check == true{
            applyCancelButton.isHidden = true
            applyButton.isHidden = false
            datePickerButton.isHidden = false
        } else{
            applyCancelButton.isHidden = false
            applyButton.isHidden = true
            datePickerButton.isHidden = true
        }
    }
    
    //MARK: Apply Button Action
    @objc func applyButtonClickAction(){
        if ud.string(forKey: "token") == nil{
            loginAlert()
        } else{
            guard let applyVC = self.storyboard?.instantiateViewController(
                withIdentifier : "ApplyViewController"
                ) as? ApplyViewController
                else{return}
            applyVC.name = name
            applyVC.addr = addr
            applyVC.period = period
            applyVC.price = price
            applyVC.img = img
            applyVC.nhIdx = nhIdx
            applyVC.schIdx = schIdx
            
            self.navigationController?.pushViewController(applyVC, animated: true)
        }
    }
    
    //MARK: Apply Cancel Button Action
    @objc func applyCancelButtonClickAction(){
        let model = ApplyModel(self)
        model.applyCancelNetworking(nhIdx: gino(nhIdx), schIdx: gino(schIdx), token: gsno(ud.string(forKey: "token")))
    }
    
    //MARK: Date Choose Button
    @objc func datePickerButtonClickAction(){
        grayBackgroundButton.isHidden = false
        
        if popupCenterYConstraint.constant == 700{
            self.popupCenterYConstraint.constant = 183.5
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else if popupCenterYConstraint.constant == 183.5{
            self.popupCenterYConstraint.constant = 700
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            self.grayBackgroundButton.isHidden = true
        }
    }
    
    @objc func hiddenGrayButtonAction(){
        self.popupCenterYConstraint.constant = 700
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        self.grayBackgroundButton.isHidden = true
    }
}


