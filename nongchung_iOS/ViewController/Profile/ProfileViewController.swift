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
    
    var myInfo = ["내가 쓴 후기"]
    var accounts = ["닉네임 변경", "비밀번호 변경", "로그아웃"]
    var supports = ["공지사항", "FAQ"]
    
    var image : UIImage?
    
    var nickname : String?
    
    let imagePicker : UIImagePickerController = UIImagePickerController()
    
    let ud = UserDefaults.standard
    
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
            self.present(self.imagePicker, animated: true, completion: {  })
        }
    }
    
    // imagePickerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        self.dismiss(animated: true) {
            self.profileInit()

        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            ProfileService.editProfileImage(image: editedImage) {

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
        } else if section == 3 {
            return supports.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat
        
        switch section {
        case 0:
            // hide the header
            headerHeight = CGFloat.leastNonzeroMagnitude
        case 4:
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
        } else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as! ButtonTableViewCell
            cell.buttonLabel.text = supports[indexPath.row]
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoginButtonTableViewCell", for: indexPath) as! LoginButtonTableViewCell
            if ud.string(forKey: "token") == "" || ud.string(forKey: "token") == nil{
                cell.loginButton.isHidden = false
                cell.loginButton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
            } else{
                cell.loginButton.isHidden = true
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 { // 내가 쓴 후기
                if ud.string(forKey: "token") == nil {
                    loginAlert()
                } else {
                    
                    let viewController = UIStoryboard(name: "More", bundle : nil).instantiateViewController(withIdentifier: "MyReviewViewController") as! MyReviewViewController
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 { // 닉네임 변경
                
                if ud.string(forKey: "token") == nil {
                    loginAlert()
                } else {
                    let nicknameViewController = UIStoryboard(name: "More", bundle : nil).instantiateViewController(withIdentifier: "NickNameViewController") as! NickNameViewController
                    nicknameViewController.nickname = nickname
                    
                    self.navigationController?.pushViewController(nicknameViewController, animated: true)
                }
                
            } else if indexPath.row == 1 { // 비밀번호 변경
                if ud.string(forKey: "token") == nil {
                    loginAlert()
                } else {
                    let passwordViewController = UIStoryboard(name: "More", bundle : nil).instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
                    self.navigationController?.pushViewController(passwordViewController, animated: true)
                }
            } else if indexPath.row == 2{ // 로그아웃
                if ud.string(forKey: "token") == nil {
                    loginAlert()
                } else {
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                    
                    //MARK: UserDefaults 파괴
                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    UserDefaults.standard.synchronize()
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                }
            }
        } else {
            if indexPath.row == 0 { // 공지사항
                let noticeViewController = UIStoryboard(name: "More", bundle : nil).instantiateViewController(withIdentifier: "NoticeTableViewController") as! NoticeTableViewController
                self.navigationController?.pushViewController(noticeViewController, animated: true)
            } else if indexPath.row == 1 { // FAQ
                let faqViewController = UIStoryboard(name: "More", bundle : nil).instantiateViewController(withIdentifier: "FAQTableViewController") as! FAQTableViewController
                self.navigationController?.pushViewController(faqViewController, animated: true)
            }
        }
    }
    
    @objc func loginButtonAction(){
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        guard let loginVC = loginStoryboard.instantiateViewController(
            withIdentifier : "LoginNavigationController"
            ) as? LoginNavigationController
            else{return}
        loginVC.modalTransitionStyle = .crossDissolve
        UIApplication.shared.keyWindow?.rootViewController = loginVC
    }
    
    
    @objc func action() {
        openGallery()
    }
}

