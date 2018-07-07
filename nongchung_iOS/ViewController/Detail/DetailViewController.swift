//
//  DetailVC.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 7..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class DetailViewController : UIViewController {
    
    @IBOutlet var heartButton: UIBarButtonItem!
    @IBOutlet var containerView: UIView!
    @IBOutlet var popupCenterYConstraint: NSLayoutConstraint!
    @IBOutlet var popupTableView: UITableView!
    
    @IBOutlet var datePickerButton: UIButton!
    @IBOutlet var applyButton: UIButton!
    @IBOutlet var grayBackgroundButton: UIButton!
    
    
    var responseMessage : IntroduceVO?
    
    let segmentedController = SJSegmentedViewController()
    var selectedSegment:SJSegmentTab?
    var offsetY: CGFloat = 0.0
    

    
    override func viewDidLoad() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.alpha = 0
        self.navigationController?.isNavigationBarHidden = false
        self.edgesForExtendedLayout = .all
        
        popupTableView.delegate = self
        popupTableView.dataSource = self
        popupTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        popupTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        popupTableView.tableHeaderView = UIView.init(frame: CGRect.zero)
        
        grayBackgroundButton.isHidden = true
        grayBackgroundButton.addTarget(self, action: #selector(hiddenGrayButtonAction), for: .touchUpInside)

        
        datePickerButton.setTitle(responseMessage?.nearestStartDate, for: .normal)
        datePickerButton.addTarget(self, action: #selector(datePickerButtonClickAction), for: .touchUpInside)
    
        segmentedSetting()
        addChildViewController(segmentedController)
        containerView.addSubview(segmentedController.view)
        segmentedController.view.frame = self.containerView.bounds
        segmentedController.didMove(toParentViewController: self)
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        //self.navigationController?.navigationBar.alpha = 1.0-(250-offsetY)/250
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.alpha = 1
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.alpha = 1
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        offsetY = scrollView.contentOffset.y
        
        if scrollView.contentOffset.y > 200 {
            UIApplication.shared.statusBarStyle = .default
        } else {
            UIApplication.shared.statusBarStyle = .lightContent
        }
        self.navigationController?.navigationBar.alpha = 1.0-(250-scrollView.contentOffset.y)/250
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "detailMainScroll"), object: self, userInfo: ["scroll":scrollView.contentOffset.y])
    }
}

extension DetailViewController : UITableViewDelegate, UITableViewDataSource {
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
        cell.periodLabel.text = responseMessage?.nearestStartDate!
        cell.departureLabel.text = index?.startDate

        if index?.state == 0{
            cell.statusLabel.text = "참가가능"
            cell.statusLabel.textColor = #colorLiteral(red: 0.9450980392, green: 0.3529411765, blue: 0.5294117647, alpha: 1)
        } else{
            cell.statusLabel.text = "모집마감"
            cell.statusLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.54)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PopupCell
        datePickerButton.setTitle(cell.periodLabel.text, for: .normal)
    }
}

extension DetailViewController {
    
    @objc func datePickerButtonClickAction(){
        grayBackgroundButton.isHidden = false
        
        if popupCenterYConstraint.constant == 500{
            self.popupCenterYConstraint.constant = 183.5
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else if popupCenterYConstraint.constant == 183.5{
            self.popupCenterYConstraint.constant = 500
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            self.grayBackgroundButton.isHidden = true
        }
    }
    
    @objc func hiddenGrayButtonAction(){
        self.popupCenterYConstraint.constant = 500
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        self.grayBackgroundButton.isHidden = true
    }
}


