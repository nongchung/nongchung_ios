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

class LoginVC: UIViewController, NetworkCallback, UIGestureRecognizerDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var animateView: UIView!
    @IBOutlet var loginCenterYConstraint: NSLayoutConstraint!
    @IBOutlet var loginStackView: UIStackView!
    @IBOutlet var logoImageView: UIImageView!
    
    
    let ud = UserDefaults.standard
    var check = true
    
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self,selector: #selector(goBackLogin),name: .goBackLogin,object: nil)
        
        let backImage = UIImage(named: "back_icon")
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        registerForKeyboardNotifications()
    }
    
    func networkResult(resultData: Any, code: String) {

        if code == "Success To Sign In"{
//            let model = APNSModel(self)
//            model.apnsTokenNetworking(deviceCategoty: 1, token: gsno(ud.string(forKey: "deviceAPNsToken")))
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            UIApplication.shared.keyWindow?.rootViewController = viewController
        }
        else if code == "Fail To Sign In"{
            simpleAlert(title: "로그인 오류", msg: "아이디 또는 패스워드를 확인해주세요.")
        }
        else if code == "Null Value"{
            simpleAlert(title: "로그인 오류", msg: "아이디 또는 패스워드를 확인해주세요.")
        }
        else if code == "Internal Server Error"{
            simpleAlert(title: "서버 오류", msg: "관리자에게 문의하세요.")
        }
//        else if code == "Success To Register Token"{
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
//            UIApplication.shared.keyWindow?.rootViewController = viewController
//        }
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
    
    //MARK: 카테고리 종료 Notification 알림
    @objc func goBackLogin(notification: NSNotification){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0){
            self.animateView.fadeIn()
            //NotificationCenter.default.removeObserver(self)
        }
    }
    
    //MARK: Keyboard Up Method
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
        ) -> Bool {
        if(touch.view?.isDescendant(of: loginStackView))!{
            return false
        }
        return true
    }
    @objc func handleTap_mainview(_ sender: UITapGestureRecognizer?){
        self.loginStackView.becomeFirstResponder()
        self.loginStackView.resignFirstResponder()
        
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(keyboardWillShow),
            name: .UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(keyboardWillHide),
            name: .UIKeyboardWillHide,
            object: nil
        )
    }
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if check {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]
                as? NSValue)?.cgRectValue {
                loginCenterYConstraint.constant = -100
                check = false
                logoImageView.isHidden = true
                view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]
            as? NSValue)?.cgRectValue {
            loginCenterYConstraint.constant = 67.5
            check = true
            logoImageView.isHidden = false
            view.layoutIfNeeded()
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
