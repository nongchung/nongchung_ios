//
//  ThemeImageTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 12..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class ThemeImageTableViewCell: UITableViewCell {

    @IBOutlet weak var themeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        increaseSeparatorHeight()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
