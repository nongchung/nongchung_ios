//
//  ScheduleCell.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 4..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var scheduleTableView: UITableView!
    
    var scheduleData : [ScheduleVO]? = nil{
        didSet{
            scheduleTableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        increaseSeparatorHeight()
        scheduleTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ScheduleCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scheduleData == nil{
            return 1
        } else{
            return (scheduleData?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        let index = scheduleData![indexPath.row]
        cell.timeLabel.text = index.time
        cell.activityLabel.text = index.activity
        cell.scheduleImageView.image = UIImage(named: "intro_schedule_icon")
        cell.scheduleTopLineImageView.isHidden = true
        if indexPath.row == (scheduleData?.count)! - 1{
            cell.scheduleBottomLineImageView.isHidden = true
            print((scheduleData?.count)! - 1)
        } else if indexPath.row == 0{
            cell.scheduleTopLineImageView.isHidden = true
        } else{
            cell.scheduleTopLineImageView.isHidden = true
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
//        let index = scheduleData![indexPath.row]
//        cell.timeLabel.text = index.time
//        cell.activityLabel.text = index.activity
//        if indexPath.row == (scheduleData?.count)! - 1{
//            cell.scheduleImageView.image = UIImage(named: "intro_schedule_icon2")
//            print((scheduleData?.count)! - 1)
//        } else{
//            cell.scheduleImageView.image = UIImage(named: "intro_schedule_icon")
//        }
//    }
    
    
    
}
