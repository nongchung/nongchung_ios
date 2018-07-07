//
//  IntroduceCell.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 4..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class IntroduceCell: UITableViewCell {

    @IBOutlet var farmAddressLabel: UILabel!
    @IBOutlet var experienceNameLabel: UILabel!
    @IBOutlet var periodLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var introduceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        increaseSeparatorHeight()
    }
}
