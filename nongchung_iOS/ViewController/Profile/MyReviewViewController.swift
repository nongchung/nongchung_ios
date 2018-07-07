//
//  MyReviewViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 7..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class MyReviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
