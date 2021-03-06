//
//  FarmerTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 12..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class FarmerTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var newImageView: UIImageView!
    @IBOutlet weak var periodImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
