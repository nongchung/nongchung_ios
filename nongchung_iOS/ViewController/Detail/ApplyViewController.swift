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
    
    @IBOutlet var activityImageView: UIImageView!
    @IBOutlet var periodLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var applyButton: UIButton!
    
    @IBOutlet var applyShadowView: UIView!
    
    let datePickerView = UIDatePicker()
    let ud = UserDefaults.standard
    
    //MARK: 농활보기에서 넘겨받은 데이터
    var name : String?
    var addr : String?
    var period : String?
    var price : Int?
    var img : String?
    var nhIdx : Int?
    var schIdx : Int?
    var chooseSchedule : String?
    var startMonth : String?
    var startDay : String?
    var endMonth : String?
    var endDay : String?
    
    var responseData : ApplyVO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        birthTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        
        applyButton.addTarget(self, action: #selector(applyButtonClickAction), for: .touchUpInside)
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

        switch code {
        case "Success To Request For Application":
            responseData = resultData as? ApplyVO
            
            guard let doneApplyVC = self.storyboard?.instantiateViewController(
                withIdentifier : "DoneApplyViewController"
                ) as? DoneApplyViewController
                else{return}
            doneApplyVC.name = name
            doneApplyVC.addr = addr
            doneApplyVC.price = price
            doneApplyVC.responseData = responseData
            doneApplyVC.startMonth = startMonth
            doneApplyVC.startDay = startDay
            doneApplyVC.endMonth = endMonth
            doneApplyVC.endDay = endDay
            self.present(doneApplyVC, animated: true, completion: nil)
        case "No token":
            let errmsg = resultData as! String
            print(errmsg)
        case "Null Value":
            let errmsg = resultData as! String
            print(errmsg)
        case "Invalid nhIdx and schIdx":
            let errmsg = resultData as! String
            print(errmsg)
        case "Invalid schIdx":
            let errmsg = resultData as! String
            print(errmsg)
        case "Duplicate To Time":
            let errmsg = resultData as! String
            print(errmsg)
            errorAlert(title: "날짜 중복", message: "농활 신청은 시간이 중복될 수 없습니다.")
        case "Fail To Request For Application, No Available Person Number":
            let errmsg = resultData as! String
            print(errmsg)
        case "Internal Server Error":
            let errmsg = resultData as! String
            print(errmsg)
        default:
            break
        }
         
    }
    
    func networkFailed() {
        simpleAlert(title: "인터넷 오류", msg: "네트워크 연결을 확인하세요.")
    }
    
}

extension ApplyViewController {
    
    func errorAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .default) { (UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(doneAction)
        present(alert, animated: true)
    }
    
    //MARK: View Setting
    func setView(){
        applyShadowView.isUserInteractionEnabled = false
        nameTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1))
        birthTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1))
        emailTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1))
        phoneTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1))
        
        activityImageView.imageFromUrl(gsno(img), defaultImgPath: gsno(img))
        titleLabel.text = name
        addressLabel.text = addr
        periodLabel.text = gsno(chooseSchedule) + " (\(gsno(period)))"
        priceLabel.text = "\(gino(price))원"
        
        let attr = NSDictionary(object: UIFont(name: "NanumSquareRoundB", size: 14)!, forKey: kCTFontAttributeName as! NSCopying)
        genderSegmentedControl.setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        
        applyShadowView.layer.shadowColor = UIColor.black.cgColor
        applyShadowView.layer.shadowOpacity = 0.16
        applyShadowView.layer.shadowOffset = CGSize.zero
        applyShadowView.layer.shadowRadius = 10
        
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
    
    @objc func applyButtonClickAction(){

        let model = ApplyModel(self)
        model.applyNetworking(nhIdx: gino(nhIdx), schIdx: gino(schIdx), token: gsno(ud.string(forKey: "token")))

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
