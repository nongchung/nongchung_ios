//
//  ButtonTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 3..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
