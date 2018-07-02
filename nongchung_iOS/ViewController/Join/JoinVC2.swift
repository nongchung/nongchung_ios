//
//  JoinVC2.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class JoinVC2: UIViewController, NetworkCallback{
    
    //MARK: JoinVC Data
    var email : String?
    var password : String?
    
    //MARK: JoinVC2 Data
    var newEmail : String?
    var newPassword : String?
    var nickname : String?
    var name : String?
    var sex = 1
    var handphone : String?
    var birth : String?
    var genderArray = ["남자", "여자"]
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var birthTextField: UITextField!
    @IBOutlet var genderTextField: UITextField!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var duplicateLabel: UILabel!
    @IBOutlet var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAddTarget()
        unableDoneBtn()
        duplicateLabel.text = ""
        let genderPickerView = UIPickerView()
        genderPickerView.delegate = self
        phoneTextField.delegate = self
        genderTextField.inputView = genderPickerView
    }
    
    //MARK: Birth TextField Editing Action
    @IBAction func birthPickerEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    func initAddTarget(){
        nameTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        nicknameTextField.addTarget(self, action: #selector(duplicateNickname), for: .editingDidEnd)
        nicknameTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        birthTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        genderTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
    }
    
    @objc func doneButtonAction(){
        newEmail = gsno(email)
        newPassword = gsno(password)
        nickname = gsno(nicknameTextField.text)
        name = gsno(nameTextField.text)
        handphone = gsno(phoneTextField.text)
        birth = gsno(birthTextField.text)
        
        let model = JoinModel(self)
        model.joinModel(email: gsno(newEmail), password: gsno(newPassword), nickname: gsno(nickname), name: gsno(name), sex: gino(sex), handphone: gsno(handphone), birth: gsno(birth))
    }
    
    func networkResult(resultData: Any, code: String) {
        print(code)
        
        //MARK: Duplication Networking Result
        if code == "duplication"{
            duplicateLabel.text = resultData as? String
        }
        else if code == "available"{
            duplicateLabel.text = resultData as? String
        }
        
        //MARK: Sign Up Networking Result
        if code == "Success To Sign Up"{
            performSegue(withIdentifier: "unwindToSplash", sender: self)
            NotificationCenter.default.post(name: .goBackLogin, object: nil)
        }
        else if code == "Null Value"{
            let errmsg = resultData as? String
            simpleAlert(title: "회원가입 오류", msg: gsno(errmsg))
        }
        else if code == "Internal Server Error"{
            let errmsg = resultData as? String
            simpleAlert(title: "서버 오류", msg: gsno(errmsg))
        }
    }
    
    func networkFailed() {
        simpleAlert(title: "인터넷 오류", msg: "네트워크 연결을 확인하세요.")
    }
}

extension JoinVC2 : UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: Date PickerView value Change Method
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthTextField.text = dateFormatter.string(from: sender.date)
    }
    
    //MARK: Gender PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderArray.count
    }
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
        return genderArray[row]
    }
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        genderTextField.text = genderArray[row]
        switch gsno(genderTextField.text) {
        case "남자":
            sex = 1
        case "여자":
            sex = 2
        default:
            break
        }
    }
    
    //MARK: Done Button isEnabled
    func unableDoneBtn(){
        self.doneButton.isEnabled = false
    }
    func enableDoneBtn(){
        self.doneButton.isEnabled = true
    }
    
    //MARK: 닉네임 중복확인
    @objc func duplicateNickname(_ sender: UITextField) {
        let model = JoinModel(self)
        if sender == nicknameTextField{
            let nickname = gsno(sender.text)
            model.duplicateNicknameModel(nickname: nickname)
        }
        isValid()
    }
    
    //MARK: TextField isEmpty 검사
    @objc func isValid(){
        if !((nameTextField.text?.isEmpty)! || (nicknameTextField.text?.isEmpty)! || (birthTextField.text?.isEmpty)! ||  (genderTextField.text?.isEmpty)! || (phoneTextField.text?.isEmpty)! || duplicateLabel.isHidden == true) {
            enableDoneBtn()
        }
        else {
            unableDoneBtn()
        }
    }
    
    
    //MARK: 전화번호 11자리 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 11
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

