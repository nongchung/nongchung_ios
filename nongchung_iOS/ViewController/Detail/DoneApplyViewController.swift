//
//  DoneApplyViewController.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 8..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class DoneApplyViewController : UIViewController {
    
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var startMonthLabel: UILabel!
    @IBOutlet var endMonthLabel: UILabel!
    @IBOutlet var startDayLabel: UILabel!
    @IBOutlet var endDayLabel: UILabel!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var numberPeopleLabel: UILabel!
    @IBOutlet var numberPeopleBottomLabel: UILabel!
    @IBOutlet var totalPeopleLabel: UILabel!
    
    @IBOutlet var doneButton: UIButton!
    
    //MARK: 넘겨받은 데이터
    var responseData : ApplyVO?
    var name : String?
    var addr : String?
    var period : String?
    var price : Int?
    
    var startMonth : String?
    var startDay : String?
    var endMonth : String?
    var endDay : String?
    
    let userName = UserDefaults.standard.string(forKey: "name")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingView()
        doneButton.addTarget(self, action: #selector(doneButtonClickAction), for: .touchUpInside)
    }
    
    func settingView(){
        nameLabel.text = "\(gsno(userName))님의"
        titleLabel.text = gsno(name)
        addressLabel.text = gsno(addr)
        priceLabel.text = "\(gino(price))원"
        numberPeopleLabel.text = "\(gino(responseData?.maxPerson)-gino(responseData?.currentPerson))명"
        numberPeopleBottomLabel.text = "\(gino(responseData?.maxPerson)-gino(responseData?.currentPerson))명"
        totalPeopleLabel.text = "\(gino(responseData?.maxPerson)-gino(responseData?.currentPerson))/\(gino(responseData?.maxPerson))"
        startMonthLabel.text = gsno(startMonth)
        startDayLabel.text = gsno(startDay)
        endMonthLabel.text = gsno(endMonth)
        endDayLabel.text = gsno(endDay)
        
        let progressRate = Float(gino(responseData?.currentPerson)) / Float(gino(responseData?.maxPerson))
        progressBar.progress = progressRate
    }
    
    @objc func doneButtonClickAction(){
        NotificationCenter.default.post(name: .gotoMain, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
