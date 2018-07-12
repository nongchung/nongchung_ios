//
//  DatePickerHeader.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 11..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class DatePickerHeader: UIView {
    
    var calendar = Calendar.current
    var dateDayNameFormat = DateFormatter()
    var dateMonthYearFormat = DateFormatter()
    
    var dayLabels: [UILabel] = {
        let days = ["S", "M", "T", "W", "T", "F", "S"]
        var labels = [UILabel]()
        
        for (i, day) in days.enumerated() {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = day
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.alpha = 1
            label.font = UIFont(name: "NanumSquareRoundB", size: 13)
            labels.append(label)
        }
        
        return labels
    }()
    
    var slashView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
                   
    var slashWidthConstraint: NSLayoutConstraint?
    var slash: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "날짜별 농활 찾기"
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.font = UIFont(name: "NanumSquareRoundB", size: 20)
        return label
    }()
    
    var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "농활을 가고 싶은 날짜를 검색해보세요."
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.font = UIFont(name: "NanumSquareRoundB", size: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dateDayNameFormat.dateFormat = "EEEE"
        dateMonthYearFormat.dateFormat = "d MMM"
        
        setupSlashView()
        setupDayLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSlashView() {
        addSubview(slashView)
        
        slashView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        slashView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        slashView.heightAnchor.constraint(lessThanOrEqualToConstant: 140).isActive = true
        slashView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        slashView.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.3215686275, blue: 0.7647058824, alpha: 1)
        
        slashView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: slashView.leadingAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: slashView.topAnchor, constant: 76).isActive = true
        
        slashView.addSubview(subTitleLabel)
        subTitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
        subTitleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: slashView.bottomAnchor, constant: -20).isActive = true
    }
    
    func setupDayLabels() {
        for (i, label) in dayLabels.enumerated() {
            addSubview(label)
            
            label.leftAnchor.constraint(equalTo: i == 0 ? leftAnchor : dayLabels[i - 1].rightAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 25).isActive = true
            label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/CGFloat(dayLabels.count)).isActive = true
            label.topAnchor.constraint(equalTo: slashView.bottomAnchor, constant: 0).isActive = true
        }
    }
}
