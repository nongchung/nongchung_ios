//
//  MyActivityViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 6..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher



class MyActivityViewController: UIViewController, NetworkCallback {
    @IBOutlet weak var myActivityTableView: UITableView!
    @IBOutlet var noReviewImageView: UIImageView!
    
    var activitys: [MyActivity] = [MyActivity]()
    
    var tcount: Int?
    var ttime: Int?
    
    let token = UserDefaults.standard.string(forKey: "token")
    var nhIdx : Int?
    var responseMessageToDetail : IntroduceVO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSetting()
        
        myActivityTableView.delegate = self
        myActivityTableView.dataSource = self
        
        myActivityTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.myActivityTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.string(forKey: "token") == nil {
            noReviewImageView.isHidden = false
        } else {
            noReviewImageView.isHidden = true
            myActivityInit()
        }
    }
    
    func myActivityInit() {
        if UserDefaults.standard.string(forKey: "token") == nil || UserDefaults.standard.string(forKey: "token") == ""{
            noReviewImageView.isHidden = false
            self.myActivityTableView.reloadData()
        }
        else {
            noReviewImageView.isHidden = true
            
            MyActivityService.myActivityInit(token: gsno(UserDefaults.standard.string(forKey: "token"))) { (myActivityTotal, myActivity)  in
                self.ttime = myActivityTotal.ttime
                self.tcount = myActivityTotal.tcount
                self.activitys = myActivity
                if self.activitys.count == 0{
                    self.noReviewImageView.isHidden = false
                } else{
                    self.noReviewImageView.isHidden = true
                }
                
                self.myActivityTableView.reloadData()
            }
        }
    }
    
    func navigationSetting(){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "NanumSquareRoundB", size: 18)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = UIColor.white
        //MARK: Navigationbar remove back button text
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //MARK: Navigationbar back button image setting
        let backImage = UIImage(named: "back_icon")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.tintColor = UIColor.black
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

extension MyActivityViewController: UITableViewDelegate, UITableViewDataSource, MyActivityViewCellDelegate {
    func myActivityTableViewReviewButton(_ sender: MyActivityTableViewCell) {
        guard let tappedIndexPath = myActivityTableView.indexPath(for: sender) else { return }
        
        //MARK: 후기가 없는 경우 (작성)
        if activitys[tappedIndexPath.row].rState == 0  {
            guard let reviewWriteVC = self.storyboard?.instantiateViewController(
                withIdentifier : "ReviewWriteViewController"
                ) as? ReviewWriteViewController
                else{ return }
            
            reviewWriteVC.reviewTitle = activitys[tappedIndexPath.row].name
            reviewWriteVC.startDate = activitys[tappedIndexPath.row].startDate
            reviewWriteVC.endDate = activitys[tappedIndexPath.row].endDate
            reviewWriteVC.period = activitys[tappedIndexPath.row].period
            reviewWriteVC.idx = activitys[tappedIndexPath.row].idx
            
            
            self.navigationController?.pushViewController(reviewWriteVC, animated: true)
        }
            //MARK: 후기가 있는 경우 (수정)
        else {
            guard let reviewEditVC = self.storyboard?.instantiateViewController(
                withIdentifier : "ReviewEditViewController"
                ) as? ReviewEditViewController
                else{ return }
            
            reviewEditVC.reviewTitle = activitys[tappedIndexPath.row].name
            reviewEditVC.startDate = activitys[tappedIndexPath.row].startDate
            reviewEditVC.endDate = activitys[tappedIndexPath.row].endDate
            reviewEditVC.period = activitys[tappedIndexPath.row].period
            reviewEditVC.idx = activitys[tappedIndexPath.row].idx
            
            self.navigationController?.pushViewController(reviewEditVC, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return activitys.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyActivityHeaderTableViewCell", for: indexPath) as! MyActivityHeaderTableViewCell
            cell.countLabel.text = String(gino(tcount))
            cell.timeLabel.text = String(gino(ttime))
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyActivityTableViewCell", for: indexPath) as! MyActivityTableViewCell
            
            let activityRow = activitys[indexPath.row]
            
            switch activityRow.state {
            //MARK: 신청중 - 입금대기
            case 0:
                cell.reviewView.isHidden = true
                cell.progressView.isHidden = false
                
                cell.mainImageView.kf.setImage(with: URL(string: gsno(activityRow.img)), placeholder: UIImage(named: "main_image2"))
                cell.titleLabel.text = activityRow.name
                cell.addressLabel.text = activityRow.addr
                cell.priceLabel.text = "\(gino(activityRow.price))원"
                cell.stateImageView.image = UIImage(named: "activity_ing")
                cell.stateImageView.image = #imageLiteral(resourceName: "activity_ing")
                
                cell.startDate.text = activityRow.startDate
                cell.endDate.text = activityRow.endDate
                
                cell.progressParticipantLabel.text = "\(gino(activityRow.personLimit)-gino(activityRow.person))"
                cell.progressCountLabel.text = "\(gino(activityRow.currentPerson))/\(gino(activityRow.personLimit))"
                // progress bar
                let progress = Float(gino(activityRow.currentPerson)) / Float(gino(activityRow.personLimit))
                cell.progress.progress = progress
                cell.participantCancelView.isHidden = true
                
                cell.selectionStyle = .none
                
            //MARK: 신청중 - 입금완료
            case 1:
                cell.reviewView.isHidden = true
                cell.progressView.isHidden = false
                
                cell.mainImageView.kf.setImage(with: URL(string: gsno(activityRow.img)), placeholder: UIImage(named: "main_image2"))
                cell.titleLabel.text = activityRow.name
                cell.addressLabel.text = activityRow.addr
                cell.priceLabel.text = "\(gino(activityRow.price))원"
                cell.cashImageView.image = #imageLiteral(resourceName: "activity_cash_ok")
                cell.stateImageView.image = UIImage(named: "activity_ing")
                
                cell.startDate.text = activityRow.startDate
                cell.endDate.text = activityRow.endDate
                
                cell.progressParticipantLabel.text = "\(gino(activityRow.personLimit)-gino(activityRow.person))"
                cell.progressCountLabel.text = "\(gino(activityRow.currentPerson))/\(gino(activityRow.personLimit))"
                // progress bar
                let progress = Float(gino(activityRow.currentPerson)) / Float(gino(activityRow.personLimit))
                cell.progress.progress = progress
                cell.participantCancelView.isHidden = true
                
                cell.selectionStyle = .none
                
            //MARK: 완료 -  rState : 0(후기없음) 1(후기있음)
            case 2:
                cell.reviewView.isHidden = false
                cell.progressView.isHidden = true
                
                cell.mainImageView.kf.setImage(with: URL(string: gsno(activityRow.img)), placeholder: UIImage(named: "main_image2"))
                cell.titleLabel.text = activityRow.name
                cell.addressLabel.text = activityRow.addr
                cell.priceLabel.text = "\(gino(activityRow.price))원"
                cell.cashImageView.image = #imageLiteral(resourceName: "activity_been")
                cell.stateImageView.isHidden = true
                
                cell.startDate.text = activityRow.startDate
                cell.endDate.text = activityRow.endDate
                
                // 후기를 썼을 경우
                if activityRow.rState == 1 {
                    cell.reviewButton.setTitle("후기수정", for: .normal)
                    cell.delegate = self
                }
                    // 후기를 안 썼을 경우
                else {
                    cell.reviewButton.setTitle("후기작성", for: .normal)
                    cell.delegate = self
                }
                
                cell.selectionStyle = .none
                
            //MARK: 취소
            case 3:
                cell.reviewView.isHidden = true
                cell.progressView.isHidden = false
                
                cell.mainImageView.image = #imageLiteral(resourceName: "activity_img_black")
                cell.titleLabel.text = activityRow.name
                cell.addressLabel.text = activityRow.addr
                cell.priceLabel.text = "\(gino(activityRow.price))원"
                cell.cashImageView.image = #imageLiteral(resourceName: "activity_cancel")
                cell.stateImageView.isHidden = true
                
                cell.startDate.text = activityRow.startDate
                cell.endDate.text = activityRow.endDate
                
                let progress = Float(gino(activityRow.currentPerson)) / Float(gino(activityRow.personLimit))
                cell.progress.progress = progress
                cell.participantOkView.isHidden = true
                cell.participantCancelView.isHidden = false
                cell.progressCountLabel.isHidden = true
                cell.progress.progressTintColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                
                let person = gino(activityRow.personLimit) - gino(activityRow.currentPerson)
                cell.cancelPeopleNumLabel.text = "\(person)"
                cell.selectionStyle = .none
                
            //MARK: 확정
            case 4:
                cell.reviewView.isHidden = true
                cell.progressView.isHidden = false
                
                cell.mainImageView.kf.setImage(with: URL(string: gsno(activityRow.img)), placeholder: UIImage(named: "main_image2"))
                cell.titleLabel.text = activityRow.name
                cell.addressLabel.text = activityRow.addr
                cell.priceLabel.text = "\(gino(activityRow.price))원"
                cell.cashImageView.image = #imageLiteral(resourceName: "activity_extension")
                cell.stateImageView.isHidden = true
                
                cell.startDate.text = activityRow.startDate
                cell.endDate.text = activityRow.endDate
                
                cell.progressParticipantLabel.text = "\(gino(activityRow.person))"
                cell.progressCountLabel.text = "\(gino(activityRow.currentPerson))/\(gino(activityRow.personLimit))"
                // progress bar
                let progress = Float(gino(activityRow.currentPerson)) / Float(gino(activityRow.personLimit))
                cell.progress.progress = progress
                cell.participantCancelView.isHidden = true
                
                cell.selectionStyle = .none
            default:
                break
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = activitys[indexPath.row]
        let model = IntroduceModel(self)
        nhIdx = index.nhidx
        model.introuduceNetworking(idx: gino(nhIdx), token: gsno(token))
    }
    
    
    @objc func reviewClickAction(_ sender: UIButton) {
        guard let reviewWriteVC = self.storyboard?.instantiateViewController(
            withIdentifier : "ReviewWriteViewController"
            ) as? ReviewWriteViewController
            else{ return }
        self.navigationController?.pushViewController(reviewWriteVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
}
