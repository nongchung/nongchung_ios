//
//  JoinVC3.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 5..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class JoinVC3 : UIViewController{
    
    @IBOutlet var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.addTarget(self, action: #selector(startButtonClickAction), for: .touchUpInside)
    }
    
    @objc func startButtonClickAction(){
        UIView.animate(withDuration: 2.0) {
            self.performSegue(withIdentifier: "unwindToSplash", sender: self)
            NotificationCenter.default.post(name: .goBackLogin, object: nil)
        }
    }
}
