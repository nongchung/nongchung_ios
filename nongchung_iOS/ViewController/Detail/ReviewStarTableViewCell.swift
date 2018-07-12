//
//  ReviewStarTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 11..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class ReviewStarTableViewCell: UITableViewCell {
    @IBOutlet weak var starLabel: UILabel!
    
    @IBOutlet weak var starTextLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
