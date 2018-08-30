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
    
    //MARK: 환불하기 아울렛
    @IBOutlet var refundAddressLabel: UILabel!
    @IBOutlet var refundTitleLabel: UILabel!
    @IBOutlet var refundStartMonthLabel: UILabel!
    @IBOutlet var refundStartDayLabel: UILabel!
    @IBOutlet var refundEndMonthLabel: UILabel!
    @IBOutlet var refundEndDayLabel: UILabel!
    @IBOutlet var refundAcceptButton: UIButton!
    @IBOutlet var refundDismissLabel: UIButton!
    @IBOutlet var refundCenterYConstraint: NSLayoutConstraint!
    @IBOutlet var refundView: UIView!
    
    var scheduleStartMonth : String = ""
    var scheduleStartDay : String = ""
    var scheduleEndMonth : String = ""
    var scheduleEndDay : String = ""
    var nearStartEndDate : String = ""
    var scheduleStartEndDateArray = [String]()
    
    var selectStartDate : String = ""
    var selectEndDate : String = ""
    
    var dateForm = DateFormatter()
    
    var dateFormatter: DateFormatter {
        get {
            let f = DateFormatter()
            f.dateFormat = "yyyy년 MM월 dd일"
            return f
        }
    }
    
    var monthCutFormatter : DateFormatter {
        get {
            let f = DateFormatter()
            f.dateFormat = "yyyy.MM"
            return f
        }
    }
    
    var dayCutFormatter : DateFormatter {
        get {
            let f = DateFormatter()
            f.dateFormat = "dd"
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

    @IBAction func heartButtonAction(_ sender: UIBarButtonItem) {
        if sender.image == #imageLiteral(resourceName: "main_heart_empty") && ud.string(forKey: "token") == nil{
            let alert = UIAlertController(title: "농활청춘", message: "로그인이 필요한 서비스 입니다. 로그인 하시겠습니까?", preferredStyle: .alert)
            let loginAction = UIAlertAction(title: "로그인", style: .default) { (UIAlertAction) in
                let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
                guard let loginVC = loginStoryboard.instantiateViewController(
                    withIdentifier : "LoginNavigationController"
                    ) as? LoginNavigationController
                    else{return}
                loginVC.modalTransitionStyle = .crossDissolve
                UIApplication.shared.keyWindow?.rootViewController = loginVC
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(cancelAction)
            alert.addAction(loginAction)
            present(alert, animated: true)
        }
        else if sender.image == #imageLiteral(resourceName: "main_heart_empty") && ud.string(forKey: "token") != nil {
            HeartService.likeAddNetworking(nhIdx: gino(nhIdx)) {
                sender.image = UIImage(named: "main_heart_fill")
            }
        }
        else{
            HeartService.likeDeleteNetworking(nhIdx: gino(nhIdx)) {
                sender.image = UIImage(named: "main_heart_empty")
            }
        }
    }
    
    
    override func viewDidLoad() {
        dateForm.dateFormat = "yyyy-MM-dd"
        
        comparableMyActivity()
        navigationbarSetting()
        scheduleTimeSetting()
        refundSetting()
        refundDismissLabel.addTarget(self, action: #selector(refundBackButtonAction), for: .touchUpInside)
        refundAcceptButton.addTarget(self, action: #selector(refundAcceptButtonAction), for: .touchUpInside)
        
        //MARK: Data Setting
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
        
        
        
        popupTableView.delegate = self
        popupTableView.dataSource = self
        popupTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        popupTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        popupTableView.tableHeaderView = UIView.init(frame: CGRect.zero)
        
        grayBackgroundButton.isHidden = true
        grayBackgroundButton.addTarget(self, action: #selector(hiddenGrayButtonAction), for: .touchUpInside)
        
        applyButton.addTarget(self, action: #selector(applyButtonClickAction), for: .touchUpInside)
        applyCancelButton.addTarget(self, action: #selector(applyCancelButtonClickAction), for: .touchUpInside)

        datePickerButton.setTitle(gsno(nearStartEndDate), for: .normal)
        datePickerButton.addTarget(self, action: #selector(datePickerButtonClickAction), for: .touchUpInside)
        
        addChildViewController(segmentedController)
        containerView.addSubview(segmentedController.view)
        segmentedController.view.frame = self.containerView.bounds
        segmentedController.didMove(toParentViewController: self)
        segmentedSetting()
        
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationbarSetting()
    }
    
    func navigationbarSetting(){
        self.navigationController?.navigationBar.topItem?.title = name
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : (UIFont(name: "NanumSquareRoundB", size: 18))!, NSAttributedStringKey.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    func scheduleTimeSetting(){
        //MARK: 가장 가까운 스케줄
        selectStartDate = gsno(responseMessage?.nearestStartDate)
        selectEndDate = gsno(responseMessage?.nearestEndDate)
        let dateStartString = gsno(responseMessage?.nearestStartDate)
        let dateEndString = gsno(responseMessage?.nearestEndDate)
    
        nearStartEndDate = "\(String(describing: dateFormatter.string(from: dateForm.date(from: dateStartString)!))) ~ \(String(describing: dayCutFormatter.string(from: dateForm.date(from: dateEndString)!)))일"
        
        //MARK: 농활 스케줄 Array
        for scheduledate in (responseMessage?.allStartDate)! {
            let scheduleStartString = gsno(scheduledate.startDate)
            let scheduleEndString = gsno(scheduledate.endDate)
            scheduleStartEndDateArray.append("\(String(describing: dateFormatter.string(from: dateForm.date(from: scheduleStartString)!))) ~ \(String(describing: dayCutFormatter.string(from: dateForm.date(from: scheduleEndString)!)))일")
        }
    }
    
    func refundSetting(){
        refundAddressLabel.text = gsno(responseMessage?.nhInfo?.addr)
        refundTitleLabel.text = gsno(responseMessage?.nhInfo?.name)
        refundStartMonthLabel.text = monthCutFormatter.string(from: dateForm.date(from: selectStartDate)!)
        refundStartDayLabel.text = dayCutFormatter.string(from: dateForm.date(from: selectStartDate)!)
        refundEndMonthLabel.text = monthCutFormatter.string(from: dateForm.date(from: selectEndDate)!)
        refundEndDayLabel.text = dayCutFormatter.string(from: dateForm.date(from: selectEndDate)!)
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
        segmentedController.headerViewHeight = 200
        segmentedController.segmentTitleFont = UIFont(name: "NanumSquareRoundB", size: 16)!
        segmentedController.segmentTitleColor = UIColor.black
        segmentedController.selectedSegmentViewColor = #colorLiteral(red: 0.2039215686, green: 0.4392156863, blue: 1, alpha: 1)
        segmentedController.segmentShadow = SJShadow.init(offset: CGSize(width: 0, height: 0), color: UIColor.clear, radius: 0, opacity: 0)
        segmentedController.segmentBounces = true
        segmentedController.delegate = self
    }
    
    func networkResult(resultData: Any, code: String) {
        if code == "Success To Cancel"{
            //MARK: Refund Popup dismiss
            self.refundCenterYConstraint.constant = 700
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.grayBackgroundButton.isHidden = true
            }
            datePickerButton.isEnabled = true
            applyCancelButton.isEnabled = true
            
            //MARK: Banner Event
            let banner = NotificationBanner(title: "취소 완료", subtitle: "농활이 취소되었습니다.", style: .danger)
            banner.show()
            banner.autoDismiss = true
            banner.haptic = .heavy
            applyCancelButton.isHidden = true
            applyButton.isHidden = false
            datePickerButton.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
            }
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
            selectedSegment?.titleColor(#colorLiteral(red: 0.2039215686, green: 0.4392156863, blue: 1, alpha: 1))
        }
    }
}

extension DetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (scheduleStartEndDateArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopupCell", for: indexPath) as! PopupCell
        let index = responseMessage?.allStartDate![indexPath.row]
        cell.periodLabel.text = gsno(scheduleStartEndDateArray[indexPath.row])
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
        selectStartDate = gsno(index?.startDate)
        selectEndDate = gsno(index?.endDate)
        datePickerButtonClickAction()
        if let myScheduleActivities = responseMessage?.myScheduleActivities{

            if myScheduleActivities.contains(gino(schIdx)) {
                applyCancelButton.isHidden = false
            }
            else{
                applyCancelButton.isHidden = true
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
        } else{
            applyCancelButton.isHidden = false
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
            applyVC.chooseSchedule = gsno(datePickerButton.titleLabel?.text)
            applyVC.price = price
            applyVC.img = img
            applyVC.nhIdx = nhIdx
            applyVC.schIdx = schIdx
            applyVC.startMonth = monthCutFormatter.string(from: dateForm.date(from: selectStartDate)!)
            applyVC.startDay = dayCutFormatter.string(from: dateForm.date(from: selectStartDate)!)
            applyVC.endMonth = monthCutFormatter.string(from: dateForm.date(from: selectEndDate)!)
            applyVC.endDay = dayCutFormatter.string(from: dateForm.date(from: selectEndDate)!)
            
            self.navigationController?.pushViewController(applyVC, animated: true)
        }
    }
    
    //MARK: Apply Cancel Button Action
    @objc func applyCancelButtonClickAction(){
        grayBackgroundButton.isHidden = false
        if refundCenterYConstraint.constant == 700{
            self.refundCenterYConstraint.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        datePickerButton.isEnabled = false
        applyCancelButton.isEnabled = false
        refundSetting()
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
    
    @objc func refundBackButtonAction(){
        if refundCenterYConstraint.constant == 0{
            self.refundCenterYConstraint.constant = 700
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.grayBackgroundButton.isHidden = true
            }
            datePickerButton.isEnabled = true
            applyCancelButton.isEnabled = true
        }
    }
    
    @objc func refundAcceptButtonAction(){
        let model = ApplyModel(self)
        model.applyCancelNetworking(nhIdx: gino(nhIdx), schIdx: gino(schIdx), token: gsno(ud.string(forKey: "token")))
    }
}


