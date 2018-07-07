//
//  ContactCell.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 6..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class ContactCell : UITableViewCell{
    
    @IBOutlet var contactCommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        increaseSeparatorHeight()
    }
    
}
