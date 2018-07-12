//
//  SearchFiliteredDataCell.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 10..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class SearchFiliteredDataCell: UITableViewCell {

    @IBOutlet var resultImageView: UIImageView!
    @IBOutlet var periodImageView: UIImageView!
    @IBOutlet var resultTitleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        increaseSeparatorHeight()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
