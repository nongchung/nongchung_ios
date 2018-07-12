//
//  QnATableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 10..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class QnATableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var QLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
