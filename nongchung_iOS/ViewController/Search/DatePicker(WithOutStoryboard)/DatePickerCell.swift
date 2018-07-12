//
//  DatePickerCell.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 11..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class DatePickerCell: BaseCell {
    
    var type: DatePickerCellType! = []
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.black
        return label
    }()
    
    var highlightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(dateLabel)
        
        dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(highlightView)
        
        highlightView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        highlightView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        highlightView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        highlightView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    func configureCell() {
        if type.contains(.Selected) || type.contains(.SelectedStartDate) || type.contains(.SelectedEndDate) || type.contains(.InBetweenDate) {
            
            dateLabel.layer.cornerRadius = 0
            dateLabel.layer.borderColor = #colorLiteral(red: 0.9490196078, green: 0.337254902, blue: 0.1254901961, alpha: 1)
            dateLabel.layer.borderWidth = 1
            dateLabel.layer.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.337254902, blue: 0.1254901961, alpha: 1)
            dateLabel.layer.mask = nil
            dateLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            if type.contains(.SelectedStartDate) {
                let side = frame.size.width / 2
                let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: side, height: side))
                let shape = CAShapeLayer()
                shape.path = maskPath.cgPath
                dateLabel.layer.mask = shape
                
            } else if type.contains(.SelectedEndDate) {
                let side = frame.size.width / 2
                let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: side, height: side))
                let shape = CAShapeLayer()
                shape.path = maskPath.cgPath
                dateLabel.layer.mask = shape
                
            } else if !type.contains(.InBetweenDate) {
                dateLabel.layer.cornerRadius = frame.size.width / 2
            }
            
        } else if type.contains(.PastDate) {
            
            dateLabel.layer.cornerRadius = 0
            dateLabel.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            dateLabel.layer.borderWidth = 0
            dateLabel.layer.backgroundColor = UIColor.clear.cgColor
            dateLabel.layer.mask = nil
            dateLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

        } else if type.contains(.Today) {
            
            dateLabel.layer.cornerRadius = self.frame.size.width / 2
            dateLabel.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.7411764706, blue: 0.6156862745, alpha: 1)
            dateLabel.layer.borderWidth = 1
            dateLabel.layer.backgroundColor = UIColor.clear.cgColor
            dateLabel.layer.mask = nil
            dateLabel.textColor = #colorLiteral(red: 0.03921568627, green: 0.7411764706, blue: 0.6156862745, alpha: 1)
            
        } else {
            
            dateLabel.layer.cornerRadius = 0
            dateLabel.layer.borderColor = UIColor.clear.cgColor
            dateLabel.layer.borderWidth = 0
            dateLabel.layer.backgroundColor = UIColor.clear.cgColor
            dateLabel.layer.mask = nil
            dateLabel.textColor = UIColor.black

        }
        
        
        if type.contains(.Highlighted) {
            highlightView.backgroundColor = UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 0.6)
            highlightView.layer.cornerRadius = frame.size.width / 2
        } else {
            highlightView.backgroundColor = UIColor.clear
        }
    }
}

struct DatePickerCellType: OptionSet {
    let rawValue: Int
    
    static let Date = DatePickerCellType(rawValue: 1 << 0)                    // has number
    static let Empty = DatePickerCellType(rawValue: 1 << 1)                   // has no number
    static let PastDate = DatePickerCellType(rawValue: 1 << 2)                // disabled
    static let Today = DatePickerCellType(rawValue: 1 << 3)                   // has circle
    static let Selected = DatePickerCellType(rawValue: 1 << 4)                // has filled circle
    static let SelectedStartDate = DatePickerCellType(rawValue: 1 << 5)       // has half filled circle on the left
    static let SelectedEndDate = DatePickerCellType(rawValue: 1 << 6)         // has half filled circle on the right
    static let InBetweenDate = DatePickerCellType(rawValue: 1 << 7)           // has filled square
    static let Highlighted = DatePickerCellType(rawValue: 1 << 8)             // has
}
