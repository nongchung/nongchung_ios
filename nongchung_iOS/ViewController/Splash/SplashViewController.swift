//
//  SplashViewController.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 12..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, NetworkCallback {

    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2.0) {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            UIApplication.shared.keyWindow?.rootViewController = viewController
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func networkResult(resultData: Any, code: String) {

    }
    
    func networkFailed() {
        print("APNS ERROR")
    }
    

}
