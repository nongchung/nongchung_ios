//
//  DatePickerFooter.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 11..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

protocol DatePickerFooterDelegate {
    func didSave()
}

class DatePickerFooter: UIView {
    
    var delegate: DatePickerFooterDelegate?
    var isSaveEnabled: Bool? {
        didSet {
            if let enabled = isSaveEnabled, enabled {
                saveButton.isEnabled = true
                saveButton.alpha = 1
            } else {
                saveButton.isEnabled = false
                saveButton.alpha = 0.5
            }
        }
    }
    
    lazy var saveButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4392156863, blue: 1, alpha: 1)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 5
        btn.setTitle("선택완료", for: .normal)
        btn.titleLabel?.font = UIFont(name: "NanumSquareRoundB", size: 15)
        btn.addTarget(self, action: #selector(DatePickerFooter.handleSave), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        addSubview(saveButton)
        
        saveButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7).isActive = true
        saveButton.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSave() {
        if let del = delegate {
            del.didSave()
        }
    }
}
