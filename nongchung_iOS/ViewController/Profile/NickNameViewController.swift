//
//  NickNameViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 5..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class NickNameViewController: UIViewController {
    
    @IBOutlet weak var textStsteLabel: UILabel!
    
    @IBOutlet weak var duplicateLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet var warningImageView: UIImageView!
    
    var limitLength = 20
    
    var nickname : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "닉네임 변경"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .done, target: self, action: #selector(applyButton))
        
        nicknameTextField.borderStyle = .none
        nicknameTextField.layer.cornerRadius = 0.0
        nicknameTextField.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 0)
        nicknameTextField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.87)
        nicknameTextField.delegate = self
        nicknameTextField.addTarget(self, action: #selector(currentLengthOfTxt), for: .editingChanged)
        nicknameTextField.addTarget(self, action: #selector(checkMaxLength(textField:)), for: .editingChanged)
        
        textStsteLabel.text = "\(nickname.characters.count)/20" // 닉네임 글자수로 바꿔줘야 함
        nicknameTextField.text = nickname
        
        duplicateLabel.isHidden = true
        warningImageView.isHidden = true

        
    }
    
    @objc func currentLengthOfTxt(){
        let length = (nicknameTextField.text?.characters.count)!
        textStsteLabel.text = "\(length)/20"
    }
    
    @objc func checkMaxLength(textField: UITextField!) {
        if (nicknameTextField.text?.characters.count)! > limitLength {
            nicknameTextField.deleteBackward()
        }
    }
    
    func editNickname(nickname: String) {
        ProfileService.editNickname(nickname: nickname) { message in
            if message == "Success to change nickname" {

                self.navigationController?.popViewController(animated: true)
                self.duplicateLabel.isHidden = true
                self.warningImageView.isHidden = true
                
            } else if message == "duplicate nickname" {

                self.duplicateLabel.isHidden = false
                self.warningImageView.isHidden = false
                
            }
        }
    }
    
    @objc func applyButton(){
        if let newNickname = nicknameTextField.text {
            editNickname(nickname: newNickname)
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nicknameTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
