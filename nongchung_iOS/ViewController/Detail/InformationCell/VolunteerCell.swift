//
//  VolunteerCell.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 4..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class VolunteerCell: UITableViewCell {

    
    @IBOutlet var titleAverageAgeLabel: UILabel!
    @IBOutlet var titleTotalVolunteerLabel: UILabel!
    @IBOutlet var averageAgeLabel: UILabel!
    @IBOutlet var nowApplyPeopleCountLabel: UILabel!
    @IBOutlet var totalApplyPeopleCountLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var womanImageview: UIImageView!
    @IBOutlet var manImageView: UIImageView!
    @IBOutlet var womanPercentLabel: UILabel!
    @IBOutlet var manPercentLabel: UILabel!
    
    
    var volunteerData : [FriendsInfoVO]? = nil{
        didSet{
            averageAgeLabel.text = "\(volunteerData?[0].ageAverage?.roundTo(places: 1) ?? 0)"
            nowApplyPeopleCountLabel.text = "\(volunteerData?[0].attendCount ?? 0)"
            totalApplyPeopleCountLabel.text = "/\(volunteerData?[0].personLimit ?? 0)"
            let womanPercent = Double((volunteerData?[0].womanCount)!) / Double((volunteerData?[0].attendCount)!)
            print(womanPercent)
            womanPercentLabel.text = "\(Double(womanPercent*100).rounded())%"
            let manPercent = Double((volunteerData?[0].manCount)!) / Double((volunteerData?[0].attendCount)!)
            manPercentLabel.text = "\(Double(manPercent*100).rounded())%"
            

            progressBar.layer.cornerRadius = 4
            progressBar.layer.masksToBounds = true
            if volunteerData?[0].attendCount == 0{
                progressBar.progress = 0.0
                progressBar.trackTintColor = #colorLiteral(red: 0.8941176471, green: 0.8941176471, blue: 0.8941176471, alpha: 1)
                womanPercentLabel.text = "0%"
                manPercentLabel.text = "0%"
            } else {
                progressBar.progress = Float(womanPercent)
                progressBar.trackTintColor = #colorLiteral(red: 0.4941176471, green: 0.6431372549, blue: 1, alpha: 1)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        increaseSeparatorHeight()
        titleAverageAgeLabel.text = "평균연령"
        titleTotalVolunteerLabel.text = "총 신청 인원"
        womanImageview.image = UIImage(named: "intro_woman")
        manImageView.image = UIImage(named: "intro_man")
        
    }
    
}

