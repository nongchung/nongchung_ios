//
//  PolicyCell.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 4..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class PolicyCell: UITableViewCell {

    @IBOutlet var refundTitleLabel: UILabel!
    @IBOutlet var refundLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        increaseSeparatorHeight()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
