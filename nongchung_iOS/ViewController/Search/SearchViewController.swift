//
//  SearchViewController.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 2..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

extension Notification.Name{
    static let dateData = Notification.Name("dateData")
    static let regionData = Notification.Name("regionData")
}

class SearchViewController : UIViewController, NetworkCallback , UIGestureRecognizerDelegate{
    
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var datePickerView: UIView!
    @IBOutlet var periodImageView: UIImageView!
    @IBOutlet var noSearchImageView: UIImageView!
    
    @IBOutlet var regionLabel: UILabel!
    @IBOutlet var regionButton: UIButton!
    @IBOutlet var peopleMinusButton: UIButton!
    @IBOutlet var peoplePlusButton: UIButton!
    @IBOutlet var peopleChooseLabel: UILabel!
    
    
    var responseMessage : SearchVO?
    var searchData = [SearchDataVO]()
    
    var startDate : String = ""
    var endDate : String = ""
    var regionData = [Int]()
    var peopleCount = 1
    var timer = Timer()
    var check = true
    
    var regionText = [0:"서울",1:"부산",2:"대구",3:"인천",4:"광주",5:"대전",6:"울산",7:"경기",8:"강원",9:"충남",10:"충북",11:"경남",12:"경북",13:"전남",14:"전북",15:"제주",16:"세종",17:"전국"]
    var regionArray = [String]()

    let token = UserDefaults.standard.string(forKey: "token")
    var nhIdx : Int?
    var responseMessageToDetail : IntroduceVO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.tableFooterView = UIView(frame: CGRect.zero)
        searchTableView.tableHeaderView = UIView(frame: CGRect.zero)
        
        NotificationCenter.default.addObserver(self, selector: #selector(dateDataNoti), name: .dateData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(regionDataNoti), name: .regionData, object: nil)
        
        regionButton.addTarget(self, action: #selector(regionButtonClickAction), for: .touchUpInside)
        peopleMinusButton.addTarget(self, action: #selector(minusButtonClickAction), for: .touchUpInside)
        peoplePlusButton.addTarget(self, action: #selector(plusButtonClickAction), for: .touchUpInside)
        peopleChooseLabel.text = "1명"
        
        setSearchBar()
        setDatePickerView()
    }
    
    func setDatePickerView(){
        let datePicker = DatePicker()
        datePicker.delegate = self
        datePickerView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: periodImageView.trailingAnchor, constant: 0).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: datePickerView.trailingAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: datePickerView.topAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: datePickerView.bottomAnchor).isActive = true
    }
    
    //MARK: SearchBar Custom Method
    func setSearchBar(){
        searchBar.delegate = self
        searchBar.placeholder = "농장 이름 및 지역명 입력"
        //MARK: 돋보기 컬러 변경
        if let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = #colorLiteral(red: 0.9490196078, green: 0.337254902, blue: 0.1254901961, alpha: 1)
        }
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
        ) -> Bool {
        if(touch.view?.isDescendant(of: searchTableView))!{
            return false
        }
        return true
    }
    @objc func handleTap_mainview(_ sender: UITapGestureRecognizer?){
        self.searchTableView.becomeFirstResponder()
        self.searchTableView.resignFirstResponder()
        
    }
    
    //MARK: Date Notification 알림
    @objc func dateDataNoti(notification: NSNotification){
        startDate = gsno(notification.userInfo!["startDate"] as? String)
        endDate = gsno(notification.userInfo!["endDate"] as? String)
        
        let model = SearchModel(self)
        model.searchNetworking(start: startDate, end: endDate, person: peopleCount, scontent: gsno(searchBar.text), area: regionData)
    }
    
    //MARK: Region Notification 알림
    @objc func regionDataNoti(notification: NSNotification){
        regionData = (notification.userInfo!["regionData"] as? [Int])!
        let model = SearchModel(self)
        model.searchNetworking(start: startDate, end: endDate, person: peopleCount, scontent: gsno(searchBar.text), area: regionData)
        
        if regionData.count == 0{
            regionLabel.text = "지역별 농활 검색"
        }
        else{
            regionLabel.text = ""
            for (k,v) in regionText{
                for i in regionData{
                    if k == i{
                        regionArray.append(v)
                    }
                }
            }
            var region = ""
            for i in regionArray{
                if i == "전국"{
                    region = "전국"
                    break
                }
                region += "\(i) "
            }
            regionLabel.text = region
            regionArray.removeAll()
        }
    }
    
    //MARK: Region Button Click Action
    @objc func regionButtonClickAction(){
        guard let regionVC = self.storyboard?.instantiateViewController(
            withIdentifier : "SearchRegionViewController"
            ) as? SearchRegionViewController
            else{return}
        regionVC.areaList = regionData
        let navigationControlr = UINavigationController(rootViewController: regionVC)
        self.present(navigationControlr, animated: true, completion: nil)
    }
    
    //MARK: Plus Minus Button Action
    @objc func minusButtonClickAction(){
        
        timer.invalidate()
        if peopleCount != 1{
            peopleCount -= 1
        } else{
            peopleCount = 1
        }
        peopleChooseLabel.text = "\(peopleCount)명"
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(autoNetworkingTimer), userInfo: nil, repeats: false)
    }
    
    @objc func plusButtonClickAction(){
        timer.invalidate()
        if peopleCount == 50{
            peopleCount = 50
        }
        peopleCount += 1
        peopleChooseLabel.text = "\(peopleCount)명"
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(autoNetworkingTimer), userInfo: nil, repeats: false)
    }
    
    @objc func autoNetworkingTimer(){
        let model = SearchModel(self)
        model.searchNetworking(start: startDate, end: endDate, person: peopleCount, scontent: gsno(searchBar.text), area: regionData)
    }
    
    func networkResult(resultData: Any, code: String) {
        if code == "Success To Get Search"{
            responseMessage = resultData as? SearchVO
            searchData = (responseMessage?.data)!
            if searchData.count == 0{
                noSearchImageView.isHidden = false
            }
            else{
                noSearchImageView.isHidden = true
            }
            
            searchTableView.reloadData()
        }
        else if code == "Internal Server Error"{
            _ = resultData as? String

        }
        else if code == "Success To Get Detail Information"{
            responseMessageToDetail = resultData as? IntroduceVO
            
            guard let detailVC = self.storyboard?.instantiateViewController(
                withIdentifier : "DetailViewController"
                ) as? DetailViewController
                else{return}
            detailVC.responseMessage = responseMessageToDetail
            detailVC.segmentedSetting()
            detailVC.nhIdx = nhIdx
            detailVC.modalTransitionStyle = .crossDissolve
            
            let navigationControlr = UINavigationController(rootViewController: detailVC)
            self.present(navigationControlr, animated: true, completion: nil)

        }
    }
    
    func networkFailed() {
        simpleAlert(title: "네트워크 오류", msg: "인터넷 연결을 확인해주세요.")
    }
    
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    //MARK: TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchFiliteredDataCell") as? SearchFiliteredDataCell else {
            return UITableViewCell()
        }
        let index = searchData[indexPath.row]
        cell.resultTitleLabel.text = index.name
        cell.addressLabel.text = index.addr
        cell.priceLabel.text = "\(gino(index.price))원"
        cell.resultImageView.imageFromUrl(gsno(index.img), defaultImgPath: gsno(index.img))
        cell.periodImageView.imageFromUrl(cell.periodCalculator(period: gsno(index.period)), defaultImgPath: cell.periodCalculator(period: gsno(index.period)))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = searchData[indexPath.row]
        let model = IntroduceModel(self)
        nhIdx = index.idx
        model.introuduceNetworking(idx: gino(nhIdx), token: gsno(token))
//        guard let detailVC = self.storyboard?.instantiateViewController(
//            withIdentifier : "DetailViewController"
//            ) as? DetailViewController
//            else{return}
//        detailVC.responseMessage = responseMessage
//        detailVC.segmentedSetting()
//        detailVC.nhIdx = index.idx
//        detailVC.modalTransitionStyle = .crossDissolve
//
//        let navigationControlr = UINavigationController(rootViewController: detailVC)
//        self.present(navigationControlr, animated: true, completion: nil)

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let model = SearchModel(self)
        model.searchNetworking(start: startDate, end: endDate, person: peopleCount, scontent: gsno(searchBar.text), area: regionData)
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
}
