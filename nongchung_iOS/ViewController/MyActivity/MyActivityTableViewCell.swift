//
//  MyActivityTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 6..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

protocol MyActivityViewCellDelegate : class {
    func myActivityTableViewReviewButton(_ sender: MyActivityTableViewCell)
}

class MyActivityTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var reviewView: UIView!

    @IBOutlet weak var participantCancelView: UIStackView!
    @IBOutlet weak var participantOkView: UIStackView!
    @IBOutlet weak var cashImageView: UIImageView!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var progressCountLabel: UILabel!
    @IBOutlet weak var progressParticipantLabel: UILabel!
    @IBOutlet weak var cancelPeopleNumLabel: UILabel!
    
    weak var delegate: MyActivityViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        //        progress.layer.cornerRadius = progress.layer.frame.height / 2.0
        //        progress.clipsToBounds = true
        //        progress.layer.sublayers![1].cornerRadius = progress.layer.frame.height / 2.0
        //        progress.subviews[1].clipsToBounds = true
        
        increaseSeparatorHeight()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    @IBAction func reviewButton(_ sender: UIButton) {
                delegate?.myActivityTableViewReviewButton(self)
    }
    
    
}
