//
//  JoinVC.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class JoinVC: UIViewController, NetworkCallback, UIGestureRecognizerDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmTextField: UITextField!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var duplicateLabel: UILabel!
    @IBOutlet var centerYConstraint: NSLayoutConstraint!
    @IBOutlet var centerStackView: UIStackView!
    
    var check = true
    
    func networkResult(resultData: Any, code: String) {
        if code == "duplication"{
            duplicateLabel.text = "중복된 이메일 입니다."
            emailTextField.textColor = UIColor.red
            duplicateLabel.textColor = UIColor.red
        }
        else if code == "available"{
            duplicateLabel.text = ""
            emailTextField.textColor = UIColor.black
        }
        isValid()
    }
    
    func networkFailed() {
        simpleAlert(title: "인터넷 오류", msg: "네트워크 연결을 확인하세요.")
    }
    
    func navigationSetting(){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "NanumSquareRoundB", size: 18)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        initAddTarget()
        unableNextBtn()
        duplicateLabel.text = ""
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
        
        emailTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1))
        passwordTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1))
        confirmTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1))

        self.title = "회원가입"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerForKeyboardNotifications()
        navigationController?.isNavigationBarHidden = false
        navigationSetting()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       unregisterForKeyboardNotifications()
        if self.isMovingFromParentViewController{
            NotificationCenter.default.post(name: .goBackLogin, object: nil)
        }
    }

    func initAddTarget(){
        emailTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(duplicateEmail), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        confirmTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        confirmTextField.addTarget(self, action: #selector(passwordConfirmCheck), for: .editingChanged)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
    }
    
    //MARK: Next Button Action
    @objc func nextButtonAction(){
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
        guard let joinVC2 = storyboard?.instantiateViewController(
            withIdentifier : "JoinVC2"
            ) as? JoinVC2
            else{return}
        joinVC2.email = gsno(emailTextField.text)
        joinVC2.password = gsno(confirmTextField.text)
        self.navigationController?.pushViewController(joinVC2, animated: true)
    }
}

extension JoinVC {
    
    //MARK: Login Button isEnabled
    func unableNextBtn(){
        self.nextButton.isEnabled = false
    }
    func enableNextBtn(){
        self.nextButton.isEnabled = true
    }
    
    //MARK: 이메일 중복확인
    @objc func duplicateEmail(_ sender: UITextField) {
        let model = JoinModel(self)
        if sender == emailTextField{
            let email = gsno(emailTextField.text)
            
            if validateEmail(enteredEmail: email){
                model.duplicateEmailModel(email: email)
            }
            else{
                duplicateLabel.text = "이메일 형식을 지켜주세요!"
                duplicateLabel.isHidden = false
                emailTextField.text = ""
            }
        }
        isValid()
    }
    
    //MARK: 이메일 정규표현식
    @objc func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    //MARK: Confirm Check Method
    @objc func passwordConfirmCheck(){
        if passwordTextField.text == confirmTextField.text {
            confirmTextField.textColor = UIColor.black
        }
        else {
            confirmTextField.textColor = UIColor.red
        }
        isValid()
    }
    
    
    //MARK: TextField isEmpty 검사
    @objc func isValid(){
        if !((emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! || (confirmTextField.text?.isEmpty)! || confirmTextField.textColor != UIColor.black || duplicateLabel.text == "중복된 이메일 입니다.") {
            enableNextBtn()
        }
        else {
            unableNextBtn()
        }
    }
    
    //MARK: Keyboard Up Method
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
        ) -> Bool {
        if(touch.view?.isDescendant(of: centerStackView))!{
            return false
        }
        return true
    }
    @objc func handleTap_mainview(_ sender: UITapGestureRecognizer?){
        self.centerStackView.becomeFirstResponder()
        self.centerStackView.resignFirstResponder()
        
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
                centerYConstraint.constant = -100
                check = false
                view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]
            as? NSValue)?.cgRectValue {
            centerYConstraint.constant = -47.5
            check = true
            view.layoutIfNeeded()
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmTextField.becomeFirstResponder()
        } else if textField == confirmTextField{
             textField.resignFirstResponder()
        }
        return true
    }
}
