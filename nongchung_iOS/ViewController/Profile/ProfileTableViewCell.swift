//
//  ProfileTableViewCell.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 3..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell  {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    //var gesture: UITapGestureRecognizer!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.layer.frame.height/2
        profileImageView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        profileImageView.layer.borderWidth = 0.1
//        self.gesture = UITapGestureRecognizer(target: self, action:#selector(imageButtonClickAction(_:)))
//        self.profileImageView.tag = 1
//        self.addGestureRecognizer(gesture)
            
    }
    
//    @IBAction func action(_ sender: UITapGestureRecognizer) {
//
//        print("dsa")
//    }
    
    
    
    
//    @objc func imageButtonClickAction(_ sender: UITapGestureRecognizer) {
//        //openGallery()
//        if let view =  sender.view {
//
//            print(self.profileImageView.tag)
//            if view.tag == 1{
//                 print(1111)
//            }
//        }
//    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
