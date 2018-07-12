//
//  DatePicker.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 11..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

public class DatePicker: UIView, DatePickerDelegate {
    
    public var selectedStartDate: Date?
    public var selectedEndDate: Date?
    public var delegate: UIViewController?
    
    var dateFormatter: DateFormatter {
        get {
            let f = DateFormatter()
            f.dateFormat = "yyyy년 MM월 dd일"
            return f
        }
    }
    
    var toServerFormatter: DateFormatter {
        get {
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd"
            return f
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var dateInputButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.white
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.adjustsImageWhenHighlighted = false
        btn.addTarget(self, action: #selector(DatePicker.showDatePicker), for: .touchUpInside)
        
        let img = UIImage(named: "Calendar", in: Bundle(for: DatePicker.self), compatibleWith: nil)
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        
        btn.setTitle("기간별 농활 검색", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.54), for: .normal)
        btn.titleLabel?.font = UIFont(name: "NanumSquareRoundB", size: 14)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        btn.titleLabel?.lineBreakMode = .byTruncatingHead
        return btn
    }()
    
    func setupViews() {
        
        addSubview(dateInputButton)

        dateInputButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        dateInputButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        dateInputButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dateInputButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    @objc func showDatePicker() {
        let datePickerViewController = DatePickerViewController(dateFrom: selectedStartDate, dateTo: selectedEndDate)
        datePickerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: datePickerViewController)
        delegate?.present(navigationController, animated: true, completion: nil)
    }
    
    public func datePickerController(_ datePickerController: DatePickerViewController, didSaveStartDate startDate: Date?, endDate: Date?) {
        selectedStartDate = startDate
        selectedEndDate = endDate
        
        if selectedStartDate == nil && selectedEndDate == nil {
            dateInputButton.setTitle("기간별 농활 검색", for: .normal)
            NotificationCenter.default.post(name: .dateData, object: nil, userInfo: ["startDate": "", "endDate": ""])
        } else {
            dateInputButton.setTitle("\(dateFormatter.string(from: startDate!)) - \(dateFormatter.string(from: endDate!))", for: .normal)
            NotificationCenter.default.post(name: .dateData, object: nil, userInfo: ["startDate":toServerFormatter.string(from: startDate!),"endDate":toServerFormatter.string(from: endDate!)])
        }
    }
}
