//
//  ProfileViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 3..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

protocol TapDelegate {
    func tapProfile()
}

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileTableView: UITableView!
    
    var profile: [Profile] = [Profile]()
    
    var myInfo = ["내가 쓴 후기", "내 포인트"]
    var accounts = ["닉네임 변경", "비밀번호 변경", "로그아웃"]
    var supports = ["공지사항", "FAQ"]
    
    var image : UIImage?
    
    var nickname : String?
    
    let imagePicker : UIImagePickerController = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.tabBarController?.tabBar.isHidden = true
        profileTableView.reloadData()
        profileInit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.navigationBar.barTintColor = UIColor.white
        //navigationController?.isNavigationBarHidden = true
        self.profileTableView.separatorStyle = .none
        
        profileTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        profileTableView.tableHeaderView = UIView.init(frame: CGRect.zero)
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : (UIFont(name: "NanumSquareRoundB", size: 18))!, NSAttributedStringKey.foregroundColor: UIColor.black]
    }
    
    func profileInit() {
        ProfileService.profileInit { (profileData) in
            self.profile = profileData
            self.profileTableView.reloadData()
        }
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = true // crop 기능
            self.present(self.imagePicker, animated: true, completion: { print("이미지 피커 나옴") })
        }
    }
    
    // imagePickerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("사용자가 취소함")
        self.dismiss(animated: true) {
            self.profileInit()
            print("이미지 피커 사라짐")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            ProfileService.editProfileImage(image: editedImage) {
                print("프로필 이미지 변경 완료")
            }
            
        }
        self.dismiss(animated: true) {
            self.profileInit()
            print("이미지 피커 사라짐")
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return profile.count
        } else if section == 1 {
            return myInfo.count
        } else if section == 2 {
            return accounts.count
        }else if section == 3 {
            return 1
        } else {
            return supports.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat
        
        switch section {
        case 0:
            // hide the header
            headerHeight = CGFloat.leastNonzeroMagnitude
        default:
            headerHeight = 30
        }
        
        return headerHeight
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell") as! ButtonTableViewCell
        
        header.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
        header.buttonLabel.font = UIFont(name: "NanumSquareRoundB", size: 12)
        header.buttonLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
        header.arrowImageView.isHidden = true
        
        if section == 1 {
            header.buttonLabel.text = "내 정보"

        } else if section == 2 {
            header.buttonLabel.text = "계정"
        } else if section == 3 {
            header.buttonLabel.text = "알림"
        } else {
            header.buttonLabel.text = "지원"
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let pCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            let index = profile[indexPath.row]
            
            nickname = index.nickname
            pCell.nicknameLabel.text = index.nickname
            pCell.emailLabel.text = index.mail
            pCell.ageLabel.text = "\(index.age)"
            pCell.nameLabel.text = index.name
            pCell.profileImageView.kf.setImage(with: URL(string: gsno(index.img)), placeholder: UIImage(named: "woman_select"))
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(action))
            pCell.profileImageView.addGestureRecognizer(gesture)
            pCell.profileImageView.isUserInteractionEnabled = true
            
            pCell.selectionStyle = .none
            
            return pCell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as! ButtonTableViewCell
            cell.buttonLabel.text = myInfo[indexPath.row]
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as! ButtonTableViewCell
            cell.buttonLabel.text = accounts[indexPath.row]
            return cell
        }
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as! ButtonTableViewCell
            cell.buttonLabel.text = "푸시알림"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as! ButtonTableViewCell
            cell.buttonLabel.text = supports[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let viewController = UIStoryboard(name: "Main", bundle : nil).instantiateViewController(withIdentifier: "MyReviewViewController") as! MyReviewViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                //                guard let farmerVC = storyboard?.instantiateViewController(
                //                    withIdentifier : "FarmerViewController"
                //                    ) as? FarmerViewController
                //                    else{return}
                //                let navigationControlr = UINavigationController(rootViewController: farmerVC)
                //                self.present(navigationControlr, animated: true, completion: nil)
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let nicknameViewController = UIStoryboard(name: "Main", bundle : nil).instantiateViewController(withIdentifier: "NickNameViewController") as! NickNameViewController
                nicknameViewController.nickname = nickname
                
                self.navigationController?.pushViewController(nicknameViewController, animated: true)
            } else if indexPath.row == 1 {
                let passwordViewController = UIStoryboard(name: "Main", bundle : nil).instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
                self.navigationController?.pushViewController(passwordViewController, animated: true)
            }
        } else if indexPath.section == 3 {
            let pushViewController = UIStoryboard(name: "Main", bundle : nil).instantiateViewController(withIdentifier: "PushViewController") as! PushViewController
            self.navigationController?.pushViewController(pushViewController, animated: true)
        }
        else if indexPath.section == 4 {
            if indexPath.row == 0 {
                let noticeViewController = UIStoryboard(name: "Main", bundle : nil).instantiateViewController(withIdentifier: "NoticeTableViewController") as! NoticeTableViewController
                self.navigationController?.pushViewController(noticeViewController, animated: true)
            } else if indexPath.row == 1 {
                let faqViewController = UIStoryboard(name: "Main", bundle : nil).instantiateViewController(withIdentifier: "FAQTableViewController") as! FAQTableViewController
                self.navigationController?.pushViewController(faqViewController, animated: true)
            }
        }
    }
    
    @objc func action() {
        openGallery()
    }
}

