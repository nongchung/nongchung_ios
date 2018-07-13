//
//  SearchRegionViewController.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 12..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class SearchRegionViewController : UIViewController{
    
    @IBOutlet var wholeCountryButton: UIButton! //17
    @IBOutlet var seoulButton: UIButton! //0
    @IBOutlet var gyeonggiButton: UIButton! //7
    @IBOutlet var incheonButton: UIButton! //3
    @IBOutlet var gangwonButton: UIButton! //8
    @IBOutlet var daejeonButton: UIButton! //5
    @IBOutlet var sejongButton: UIButton! //16
    @IBOutlet var chungnamButton: UIButton! //9
    @IBOutlet var chungbukButton: UIButton! //10
    @IBOutlet var busanButton: UIButton! //1
    @IBOutlet var ulsanButton: UIButton! //6
    @IBOutlet var gyeongnamButton: UIButton! //11
    @IBOutlet var gyeongbukButton: UIButton! //12
    @IBOutlet var daeguButton: UIButton! //2
    @IBOutlet var gwangjuButton: UIButton! //4
    @IBOutlet var jeonnamButton: UIButton! //13
    @IBOutlet var jeonbukButton: UIButton! //14
    @IBOutlet var jejuButton: UIButton! //15
    
    
    @IBOutlet var doneButton: UIButton!
    
    var areaList = [Int]()
    @IBOutlet var regionButton : [UIButton]!
    
    lazy var dismissButton: UIBarButtonItem = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "Delete"), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        let barBtn = UIBarButtonItem(customView: btn)
        return barBtn
    }()
    
    lazy var clearButton: UIBarButtonItem = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("초기화", for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        btn.titleLabel?.font = UIFont(name: "NanumSquareRoundB", size: 20)
        btn.addTarget(self, action: #selector(handleClearInput), for: .touchUpInside)
        let barBtn = UIBarButtonItem(customView: btn)
        return barBtn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        buttonSetting()
        doneButton.addTarget(self, action: #selector(doneClickAction), for: .touchUpInside)
    }
    
    @objc func doneClickAction(){
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .regionData, object: nil, userInfo: ["regionData":self.areaList])
        }
    }
    
    func buttonSetting(){
        for button in self.regionButton{
            button.layer.borderWidth = 1.0
            button.layer.borderColor = #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1)
            button.addTarget(self, action: #selector(regionButtonClickAction), for: .touchUpInside)
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        wholeCountryButton.tag = 17
        seoulButton.tag = 0
        gyeonggiButton.tag = 7
        incheonButton.tag = 3
        gangwonButton.tag = 8
        daejeonButton.tag = 5
        sejongButton.tag = 16
        chungnamButton.tag = 9
        chungbukButton.tag = 10
        busanButton.tag = 1
        ulsanButton.tag = 6
        gyeongnamButton.tag = 11
        gyeongbukButton.tag = 12
        daeguButton.tag = 2
        gwangjuButton.tag = 4
        jeonnamButton.tag = 13
        jeonbukButton.tag = 14
        jejuButton.tag = 15
        
        //MARK: 기존 선택 버튼 불러오기
        for button in regionButton{
            if areaList.contains(button.tag){
                button.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4392156863, blue: 1, alpha: 1)
                button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                button.layer.borderColor = #colorLiteral(red: 0.2039215686, green: 0.4392156863, blue: 1, alpha: 1)
            }else{
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                button.setTitleColor(#colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1), for: .normal)
                button.layer.borderColor = #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1)
            }
        }
    }
    
    @objc func regionButtonClickAction(_ sender: UIButton){
        if sender.tag == 17 && sender.backgroundColor == #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0){
            for button in self.regionButton{
                button.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4392156863, blue: 1, alpha: 1)
                button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                button.layer.borderColor = #colorLiteral(red: 0.2039215686, green: 0.4392156863, blue: 1, alpha: 1)
                areaList.append(button.tag)
            }
        } else if sender.tag == 17 && sender.backgroundColor == #colorLiteral(red: 0.2039215686, green: 0.4392156863, blue: 1, alpha: 1){
            for button in self.regionButton{
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                button.setTitleColor(#colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1), for: .normal)
                button.layer.borderColor = #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1)
                areaList.removeAll()
            }
        } else if wholeCountryButton.backgroundColor == #colorLiteral(red: 0.2039215686, green: 0.4392156863, blue: 1, alpha: 1) && sender.tag != 17{
            wholeCountryButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            wholeCountryButton.setTitleColor(#colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1), for: .normal)
            wholeCountryButton.layer.borderColor = #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1)
            sender.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            sender.setTitleColor(#colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1), for: .normal)
            sender.layer.borderColor = #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1)
            if let index = areaList.index(of: 17) {
                areaList.remove(at: index)
            }
            if let index = areaList.index(of: sender.tag) {
                areaList.remove(at: index)
            }
        }
        else{
            if sender.backgroundColor == #colorLiteral(red: 0.2039215686, green: 0.4392156863, blue: 1, alpha: 1){
                sender.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                sender.setTitleColor(#colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1), for: .normal)
                sender.layer.borderColor = #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1)
                //MARK: Button Area List 요소 검색
                if areaList.index(where: { $0 == sender.tag })
                    .map({ areaList.remove(at: $0) }) != nil {
                }
            }
            else {
                sender.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4392156863, blue: 1, alpha: 1)
                sender.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                sender.layer.borderColor = #colorLiteral(red: 0.2039215686, green: 0.4392156863, blue: 1, alpha: 1)
                areaList.append(sender.tag)
            }
        }
    }
}

extension SearchRegionViewController {
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationItem.setLeftBarButton(dismissButton, animated: true)
        self.navigationItem.setRightBarButton(clearButton, animated: true)
    }
    
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleClearInput() {
        areaList.removeAll()
        for button in regionButton{
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            button.setTitleColor(#colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1), for: .normal)
            button.layer.borderColor = #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1)
        }
    }
}
