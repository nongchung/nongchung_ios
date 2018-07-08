//
//  Extension.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import Kingfisher

extension UITableViewCell{
    
    //MARK: Separator Height Increase Method
    func increaseSeparatorHeight(){
        let mScreenSize = UIScreen.main.bounds
        let mSeparatorHeight = CGFloat(10.0)
        let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
        mAddSeparator.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
        self.addSubview(mAddSeparator)
    }
}

extension UITextField {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height-height+5, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}

extension UIView {
    
    func fadeIn(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

extension UIImageView {
    public func imageFromUrl(_ urlString: String?, defaultImgPath : String) {
        let defaultImg = UIImage(named: defaultImgPath)
        if let url = urlString {
            if url.isEmpty {
                self.image = defaultImg
            } else {
                self.kf.setImage(with: URL(string: url), placeholder: defaultImg, options: [.transition(ImageTransition.fade(0.5))])
            }
        } else {
            self.image = defaultImg
        }
    }
}

extension UITableViewCell{
    //MARK: Period 계산기
    public func periodCalculator(period: String) -> String{
        switch period {
        case "1박 2일":
            return "main_day_icon"
        case "2박 3일":
            return "main_day_icon2"
        case "당일치기":
            return "main_day_icon3"
        default:
            return ""
        }
    }
    
    //MARK: Star 계산기
    public func starCalculator(star: Double) -> String{
        if star <= 1{
            return "star0_icon_small"
        } else if star > 1 && star <= 2{
            return "star1_icon_small"
        } else if star > 2 && star <= 3{
            return "star1_icon_small"
        } else if star > 3 && star <= 4{
            return "star2_icon_small"
        } else if star > 4 && star <= 5{
            return "star2_icon_small"
        } else if star > 5 && star <= 6{
            return "star3_icon_small"
        } else if star > 6 && star <= 7{
            return "star3_icon_small"
        } else if star > 7 && star <= 8{
            return "star4_icon_small"
        } else if star > 8 && star <= 9{
            return "star4_icon_small"
        } else if star > 9 && star <= 10{
            return "star5_icon_small"
        } else{
            return "star0_icon_small"
        }
        
    }
}

extension UIViewController : UITextFieldDelegate, UIScrollViewDelegate{
    
    func loginAlert(){
        let alert = UIAlertController(title: "농활청춘", message: "로그인이 필요합니다. 로그인 하시겠습니까?", preferredStyle: .alert)
        let loginAction = UIAlertAction(title: "로그인", style: .default) { (UIAlertAction) in
            let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
            guard let loginVC = loginStoryboard.instantiateViewController(
                withIdentifier : "LoginVC"
                ) as? LoginVC
                else{return}
            self.present(loginVC, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(loginAction)
        present(alert, animated: true)
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    func gsno(_ data: String?) -> String {
        guard let str = data else {
            return ""
        }
        return str
    }
    
    func gino(_ data: Int?) -> Int {
        guard let num = data else {
            return 0
        }
        return num
    }
    
    func simpleAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func getCurrentMillis()->Int64 {
        return Int64(Int64(Date().timeIntervalSince1970 * 1000))
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    
}
