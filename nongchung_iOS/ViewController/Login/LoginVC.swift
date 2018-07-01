//
//  LoginVC.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, NetworkCallback {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    let ud = UserDefaults.standard
    
    //MARK: Outlet Add Action
    func initAddTarget(){
        loginButton.addTarget(self, action: #selector(loginNetworking), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
    }
    
    //MARK: Login Button isEnabled
    func unableLoginBtn(){
        self.loginButton.isEnabled = false
    }
    func enableLoginBtn(){
        self.loginButton.isEnabled = true
    }
    
    //MARK: Login Networking
    @objc func loginNetworking() {
        let model = LoginModel(self)
        let user_mail = gsno(emailTextField.text)
        let user_pw = gsno(passwordTextField.text)
        model.login(user_mail: user_mail, user_pw: user_pw)
    }
    
    //MARK: LoginTextField isEmpty 검사
    @objc func isValid(){
        if !((emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!) {
            enableLoginBtn()
        }
        else {
            unableLoginBtn()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAddTarget()
        unableLoginBtn()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    func networkResult(resultData: Any, code: String) {
        if code == "success"{
            let token = resultData as? String
            ud.setValue(gsno(token), forKey: "token")
            ud.synchronize()
            print(token)
        }
    }
    
    func networkFailed() {
        simpleAlert(title: "인터넷 오류", msg: "네트워크 연결을 확인하세요.")
    }
    
}
