//
//  DatePickerMonthHeader.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 11..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class DatePickerMonthHeader: BaseCell {

    var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont(name: "NanumSquareRoundB", size: 24)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(monthLabel)
        monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        monthLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        monthLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
