//
//  JoinVC.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class JoinVC: UIViewController, NetworkCallback {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmTextField: UITextField!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var duplicateLabel: UILabel!
    
    func networkResult(resultData: Any, code: String) {
        if code == "duplication"{
            duplicateLabel.text = resultData as? String
        }
        else if code == "available"{
            duplicateLabel.text = resultData as? String
        }
    }
    
    func networkFailed() {
        simpleAlert(title: "인터넷 오류", msg: "네트워크 연결을 확인하세요.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAddTarget()
        unableNextBtn()
        duplicateLabel.text = ""
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
                duplicateLabel.text = "중복된 이메일 입니다."
                duplicateLabel.isHidden = false
                duplicateLabel.text = ""
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
        if !((emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! || (confirmTextField.text?.isEmpty)! || confirmTextField.textColor != UIColor.black || duplicateLabel.isHidden == true) {
            enableNextBtn()
        }
        else {
            unableNextBtn()
        }
    }
}
