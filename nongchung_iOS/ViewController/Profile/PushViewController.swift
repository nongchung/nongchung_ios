//
//  PushViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 5..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import UserNotifications

class PushViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet var pushSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "푸시알림"
        pushSwitch.addTarget(self, action: #selector(pushNotificationSwitch), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pushNotificationSwitchState()
    }
}

extension PushViewController {

    //MARK: 푸시알림 현재 상태 스위치
    @objc func pushNotificationSwitchState(){
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized{
                DispatchQueue.main.async {
                    self.pushSwitch.setOn(true, animated: true)
                }
            }
            else {
                DispatchQueue.main.async {
                    self.pushSwitch.setOn(false, animated: true)
                }
            }
        }
    }
    
    //MARK: 푸시알림 권한 스위치
    @objc func pushNotificationSwitch(_ sender: UISwitch){
        
        if sender.isOn {
            notificationAllowAlert()
        } else{
            notificationAllowAlert()
        }
    }
    
    //MARK: 농활청춘 알림 Setting Present Alert
    func notificationAllowAlert(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in

            UNUserNotificationCenter.current().delegate = self
            let alertController = UIAlertController(title: "푸시알림 설정", message: "설정에서 알림을 설정해주세요", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "설정", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    })
                }
            }
            let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
