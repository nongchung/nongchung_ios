//
//  MyActivityViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 6..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class MyActivityViewController: UIViewController {
    @IBOutlet weak var myActivityTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myActivityTableView.delegate = self
        myActivityTableView.dataSource = self
        myActivityTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}

extension MyActivityViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyActivityHeaderTableViewCell", for: indexPath) as! MyActivityHeaderTableViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyActivityTableViewCell", for: indexPath) as! MyActivityTableViewCell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    

}
