//
//  JoinVC2.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class JoinVC2: UIViewController, NetworkCallback, UIGestureRecognizerDelegate{
    
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
    
    var check = true
    let genderPickerView = UIPickerView()
    let datePickerView = UIDatePicker()
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var birthTextField: UITextField!
    @IBOutlet var genderTextField: UITextField!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var duplicateLabel: UILabel!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var centerStackView: UIStackView!
    @IBOutlet var centerYConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        initAddTarget()
        unableDoneBtn()
        duplicateLabel.text = ""
        
        nameTextField.delegate = self
        nicknameTextField.delegate = self
        birthTextField.delegate = self
        genderTextField.delegate = self
        phoneTextField.delegate = self
        
        nameTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1))
        nicknameTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1))
        birthTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1))
        genderTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1))
        phoneTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1))
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderPickerView.backgroundColor = UIColor.white
        genderPickerView.showsSelectionIndicator = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "확인", style: UIBarButtonItemStyle.done, target: self, action: #selector(donePicker))
        let cancelButton = UIBarButtonItem(title: "취소", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        genderTextField.inputView = genderPickerView
        genderTextField.inputAccessoryView = toolBar
        birthTextField.inputAccessoryView = toolBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
        navigationSetting()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    func navigationSetting(){
        navigationController?.navigationBar.topItem?.title = "회원가입"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "NanumSquareRoundB", size: 18)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
    }
    
    //MARK: Birth TextField Editing Action
    @IBAction func birthPickerEditing(_ sender: UITextField) {
        datePickerView.backgroundColor = UIColor.white
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: -16, to: Date())
        datePickerView.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
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

        
        //MARK: Duplication Networking Result
        if code == "duplication"{
            duplicateLabel.text = "중복된 닉네임 입니다."
            nicknameTextField.textColor = UIColor.red
            duplicateLabel.textColor = UIColor.red
        }
        else if code == "available"{
            duplicateLabel.text = ""
            nicknameTextField.textColor = UIColor.black
        }
        isValid()
        
        //MARK: Sign Up Networking Result
        if code == "Success To Sign Up"{
            UIView.animate(withDuration: 2.0) {
                guard let joinVC = self.storyboard?.instantiateViewController(
                    withIdentifier : "JoinVC3"
                    ) as? JoinVC3
                    else{return}
                joinVC.modalTransitionStyle = .crossDissolve
                self.present(joinVC, animated: true, completion: nil)
            }
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
        if !((nameTextField.text?.isEmpty)! || (nicknameTextField.text?.isEmpty)! || (birthTextField.text?.isEmpty)! ||  (genderTextField.text?.isEmpty)! || (phoneTextField.text?.isEmpty)! || duplicateLabel.text == "중복된 닉네임 입니다.") {
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
                centerYConstraint.constant = -70
                check = false
                view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]
            as? NSValue)?.cgRectValue {
            centerYConstraint.constant = -3.5
            check = true
            view.layoutIfNeeded()
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            nicknameTextField.becomeFirstResponder()
        } else if textField == nicknameTextField {
            birthTextField.becomeFirstResponder()
        } else if textField == birthTextField{
            genderTextField.becomeFirstResponder()
        } else if textField == genderTextField{
            phoneTextField.becomeFirstResponder()
        } else if textField == phoneTextField{
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func donePicker() {
        genderTextField.resignFirstResponder()
        birthTextField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == genderTextField{
            self.genderPickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(genderPickerView, didSelectRow: 0, inComponent: 0)
        }
    }
}

