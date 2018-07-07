//
//  FarmerCell.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 4..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class FarmerCell: UITableViewCell {

    
    @IBOutlet var farmerImageView: UIImageView!
    @IBOutlet var farmerStatusLabel: UILabel!
    @IBOutlet var farmerNameLabel: UILabel!
    @IBOutlet var introduceLabel: UILabel!
    @IBOutlet var farmerProfileButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        increaseSeparatorHeight()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
