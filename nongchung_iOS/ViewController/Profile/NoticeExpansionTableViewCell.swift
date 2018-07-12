//
//  NoticeExpansionTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 5..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class NoticeExpansionTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.font = UIFont(name: "NanumSquareRoundB", size: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
