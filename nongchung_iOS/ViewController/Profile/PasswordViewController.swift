//
//  PasswordViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 5..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PasswordViewController: UIViewController {
    @IBOutlet weak var originPwLabel: UITextField!
    @IBOutlet weak var newPwLabel: UITextField!
    @IBOutlet weak var duplicateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .done, target: self, action: #selector(addTapped))
        
        self.title = "비밀번호 변경"
        
        originPwLabel.placeholder = "비밀번호를 입력하세요"
        newPwLabel.placeholder = "비밀번호를 입력하세요"
        
        originPwLabel.borderStyle = .none
        newPwLabel.borderStyle = .none
        
        originPwLabel.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 0.54))
        newPwLabel.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 0.54))
        
        duplicateLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }

    func editPassword(password: String, newpw: String) {
        ProfileService.editPassword(password: password, newpw: newpw) { message in
            if message == "Success To change PW" {
                self.navigationController?.popViewController(animated: true)
            } else if message == "fail To change PW from client" {
                self.duplicateLabel.isHidden = false
            }
        }
    }
    
    @objc func addTapped(){
        if let originPw = originPwLabel.text, let newPw = newPwLabel.text {
            editPassword(password: originPw, newpw: newPw)
        }
    }

}
