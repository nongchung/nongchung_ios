//
//  ApplyViewController.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 8..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class ApplyViewController : UIViewController, NetworkCallback {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var birthTextField: UITextField!
    @IBOutlet var genderSegmentedControl: UISegmentedControl!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var activityImageView: UIImageView!
    @IBOutlet var periodLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var applyButton: UIButton!
    
    @IBOutlet var applyShadowView: UIView!
    
    let datePickerView = UIDatePicker()
    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        birthTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        
        userDataSetting()
        setView()
        
    }
    
    @IBAction func birthEditingAction(_ sender: UITextField) {
        datePickerView.backgroundColor = UIColor.white
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: -16, to: Date())
        datePickerView.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    func networkResult(resultData: Any, code: String) {
        
         
    }
    
    func networkFailed() {
        simpleAlert(title: "인터넷 오류", msg: "네트워크 연결을 확인하세요.")
    }
    
}

extension ApplyViewController {
    
    //MARK: View Setting
    func setView(){
        nameTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1))
        birthTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1))
        emailTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1))
        phoneTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1))
        
        let attr = NSDictionary(object: UIFont(name: "NanumSquareRoundB", size: 14)!, forKey: kCTFontAttributeName as! NSCopying)
        genderSegmentedControl.setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        
        applyShadowView.layer.shadowColor = UIColor.black.cgColor
        applyShadowView.layer.shadowOpacity = 0.16
        applyShadowView.layer.shadowOffset = CGSize.zero
        applyShadowView.layer.shadowRadius = 10
        
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "확인", style: UIBarButtonItemStyle.done, target: self, action: #selector(donePicker))
        let cancelButton = UIBarButtonItem(title: "취소", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        birthTextField.inputAccessoryView = toolBar
    }
    
    //MARK: User Data Setting
    func userDataSetting(){
        nameTextField.text = ud.string(forKey: "name")
        birthTextField.text = ud.string(forKey: "birth")
        emailTextField.text = ud.string(forKey: "mail")
        phoneTextField.text = ud.string(forKey: "hp")
        
        switch ud.integer(forKey: "sex") {
        case 1:
            genderSegmentedControl.selectedSegmentIndex = 1
        case 2:
            genderSegmentedControl.selectedSegmentIndex = 0
        default:
            break
        }
    }
    
    //MARK: Date PickerView value Change Method
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func donePicker() {
        birthTextField.resignFirstResponder()
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            birthTextField.becomeFirstResponder()
        } else if textField == birthTextField {
            textField.resignFirstResponder()
        }
        if textField == emailTextField{
            phoneTextField.becomeFirstResponder()
        } else if textField == phoneTextField{
            textField.resignFirstResponder()
        }
        return true
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
