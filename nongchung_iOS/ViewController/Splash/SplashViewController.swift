//
//  SplashViewController.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 12..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import Lottie

class SplashViewController: UIViewController, NetworkCallback {

    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationView = LOTAnimationView(name: "data")
        animationView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
            
        view.addSubview(animationView)
            
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
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
