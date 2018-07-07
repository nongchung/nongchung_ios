//
//  MyActivityTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 6..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class MyActivityTableViewCell: UITableViewCell {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var progressCountLabel: UILabel!
    @IBOutlet weak var progressParticipantLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
//        progress.layer.cornerRadius = progress.layer.frame.height / 2.0
//        //progress.layer.cornerRadius = progress.layer.frame.height / 2.0
//        progress.clipsToBounds = true
//        progress.layer.sublayers![1].cornerRadius = progress.layer.frame.height / 2.0
//        progress.subviews[1].clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
