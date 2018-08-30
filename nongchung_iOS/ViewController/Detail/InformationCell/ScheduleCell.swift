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
        cell.selectionStyle = .none
        cell.timeLabel.text = index.time
        cell.activityLabel.text = index.activity
        cell.scheduleImageView.image = UIImage(named: "intro_schedule_circle_icon")
        cell.scheduleTopLineImageView.image = UIImage(named: "intro_schedule_white_line")
        if indexPath.row == (scheduleData?.count)! - 1 && scheduleData?.count != 1{
            cell.scheduleBottomLineImageView.image = UIImage(named: "intro_schedule_white_line")
            cell.scheduleTopLineImageView.image = UIImage(named: "intro_schedule_line")
        } else if indexPath.row == 0 && scheduleData?.count != 1{
            cell.scheduleTopLineImageView.image = UIImage(named: "intro_schedule_white_line")
            cell.scheduleBottomLineImageView.image = UIImage(named: "intro_schedule_line")
        } else if indexPath.row == (scheduleData?.count)! - 1 && scheduleData?.count == 1{
            cell.scheduleBottomLineImageView.image = UIImage(named: "intro_schedule_white_line")
            cell.scheduleTopLineImageView.image = UIImage(named: "intro_schedule_white_line")
        } else {
            cell.scheduleTopLineImageView.image = UIImage(named: "intro_schedule_line")
            cell.scheduleBottomLineImageView.image = UIImage(named: "intro_schedule_line")
        }
        return cell
    }
}
