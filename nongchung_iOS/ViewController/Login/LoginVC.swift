//
//  LoginVC.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

extension Notification.Name{
    static let goBackLogin = Notification.Name("goBackLogin")
}

class LoginVC: UIViewController, NetworkCallback {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var animateView: UIView!
    
    let ud = UserDefaults.standard
    
    @IBAction func unwindToSplash(segue:UIStoryboardSegue) { }
    
    //MARK: Outlet Add Action
    func initAddTarget(){
        loginButton.addTarget(self, action: #selector(loginNetworking), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        signupButton.addTarget(self, action: #selector(signupButtonAction), for: .touchUpInside)
    }
    
    //MARK: SignUp Button Action
    @objc func signupButtonAction(){
        animateView.fadeOut()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0){
            guard let joinVC = self.storyboard?.instantiateViewController(
                withIdentifier : "JoinVC"
                ) as? JoinVC
                else{return}
            self.navigationController?.pushViewController(joinVC, animated: true)
        }
    }
    
    //MARK: Login Networking
    @objc func loginNetworking() {
        let model = LoginModel(self)
        let email = gsno(emailTextField.text)
        let password = gsno(passwordTextField.text)
        
        model.login(email: email, password: password)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAddTarget()
        unableLoginBtn()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self,selector: #selector(goBackLogin),name: .goBackLogin,object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true

    }
    
    func networkResult(resultData: Any, code: String) {
        if code == "success"{
            let token = resultData as? String
            ud.setValue(gsno(token), forKey: "token")
            ud.synchronize()
        }
    }
    
    func networkFailed() {
        simpleAlert(title: "인터넷 오류", msg: "네트워크 연결을 확인하세요.")
    }
    
}

extension LoginVC {
    
    //MARK: Login Button isEnabled
    func unableLoginBtn(){
        self.loginButton.isEnabled = false
    }
    func enableLoginBtn(){
        self.loginButton.isEnabled = true
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
    
    // 카테고리 종료 Notification 알림
    @objc func goBackLogin(notification: NSNotification){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0){
            self.animateView.fadeIn()
            //NotificationCenter.default.removeObserver(self)
        }
    }
}
